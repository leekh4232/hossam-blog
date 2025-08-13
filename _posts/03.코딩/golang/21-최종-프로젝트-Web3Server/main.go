package main

import (
	"crypto/ecdsa"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

// Message는 사용자가 서명할 데이터의 구조를 정의합니다.
type Message struct {
	Content   string    `json:"content"`
	Timestamp time.Time `json:"timestamp"`
}

// SignedMessage는 원본 메시지와 서명, 공개키를 함께 담습니다.
// 이 구조체가 클라이언트와 서버 간에 교환됩니다.
type SignedMessage struct {
	Message   Message `json:"message"`
	Signature string  `json:"signature"`
	PublicKey string  `json:"publicKey"`
}

// 서명되고 검증된 메시지들을 저장하는 인메모리 슬라이스입니다.
// 데이터베이스를 대체하는 간단한 저장소 역할을 합니다.
var verifiedMessages []SignedMessage

// 1. 키 쌍 생성 (ECDSA - 타원 곡선 디지털 서명 알고리즘)
// 실제 지갑(Wallet)이 하는 역할과 유사합니다.
func generateKeys() (*ecdsa.PrivateKey, ecdsa.PublicKey) {
	// P-256은 보안과 성능이 균형 잡힌 타원 곡선입니다.
	privateKey, err := ecdsa.GenerateKey(ecdsa.P256(), rand.Reader)
	if err != nil {
		log.Fatalf("키 생성 실패: %v", err)
	}
	return privateKey, privateKey.PublicKey
}

// 2. 데이터 서명
// 주어진 개인키로 메시지 데이터에 서명합니다.
func sign(privateKey *ecdsa.PrivateKey, data []byte) (string, error) {
	// 서명할 데이터는 먼저 해시(hash)되어야 합니다.
	// 데이터가 길어도 고정된 길이의 해시값으로 축약됩니다.
	hash := sha256.Sum256(data)

	// 개인키로 해시값에 서명합니다.
	signature, err := ecdsa.SignASN1(rand.Reader, privateKey, hash[:])
	if err != nil {
		return "", err
	}
	// 서명 결과를 16진수 문자열로 변환하여 반환합니다.
	return hex.EncodeToString(signature), nil
}

// 3. 서명 검증
// 공개키를 사용하여 서명이 유효한지 확인합니다.
func verify(publicKeyBytes []byte, signature string, data []byte) bool {
    // 16진수 문자열로 된 서명을 다시 바이트 슬라이스로 디코딩합니다.
    sigBytes, err := hex.DecodeString(signature)
    if err != nil {
        return false
    }

    // 서명 생성 때와 동일하게 데이터의 해시를 계산합니다.
    hash := sha256.Sum256(data)

    // 공개키 바이트를 실제 ecdsa.PublicKey 객체로 변환합니다.
    pubKey := new(ecdsa.PublicKey)
    pubKey.Curve = ecdsa.P256()
    pubKey.X, pubKey.Y = pubKey.Curve.ScalarBaseMult(publicKeyBytes)

    // 공개키, 해시, 서명 바이트를 사용하여 서명을 검증합니다.
    return ecdsa.VerifyASN1(pubKey, hash[:], sigBytes)
}

// '/submit' 엔드포인트 핸들러
// 클라이언트로부터 서명된 메시지를 받아 검증하고 저장합니다.
func handleSubmit(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "POST 메서드만 허용됩니다.", http.StatusMethodNotAllowed)
		return
	}

	var signedMsg SignedMessage
	// 요청 본문의 JSON을 SignedMessage 구조체로 디코딩합니다.
	if err := json.NewDecoder(r.Body).Decode(&signedMsg); err != nil {
		http.Error(w, "잘못된 요청 본문입니다.", http.StatusBadRequest)
		return
	}

	// 공개키 문자열을 바이트 슬라이스로 변환합니다.
	pubKeyBytes, err := hex.DecodeString(signedMsg.PublicKey)
	if err != nil {
		http.Error(w, "잘못된 공개키 형식입니다.", http.StatusBadRequest)
		return
	}

	// 메시지를 JSON 바이트로 변환하여 서명 검증에 사용합니다.
	msgBytes, err := json.Marshal(signedMsg.Message)
	if err != nil {
		http.Error(w, "메시지 직렬화 실패.", http.StatusInternalServerError)
		return
	}

	// 서명을 검증합니다.
	if !verify(pubKeyBytes, signedMsg.Signature, msgBytes) {
		http.Error(w, "서명이 유효하지 않습니다.", http.StatusUnauthorized)
		return
	}

	// 검증 성공 시, 메시지를 저장합니다.
	verifiedMessages = append(verifiedMessages, signedMsg)
	fmt.Printf("검증 성공 및 메시지 저장: %s\n", signedMsg.Message.Content)

	w.WriteHeader(http.StatusCreated)
	fmt.Fprintln(w, "메시지가 성공적으로 검증 및 저장되었습니다.")
}

// '/messages' 엔드포인트 핸들러
// 저장된 모든 검증된 메시지 목록을 반환합니다.
func handleGetMessages(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "GET 메서드만 허용됩니다.", http.StatusMethodNotAllowed)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(verifiedMessages)
}

// '/sign-test' 엔드포인트 핸들러 (학습용)
// 키 생성, 메시지 생성, 서명 과정을 시뮬레이션하여 클라이언트에게 보여줍니다.
func handleSignTest(w http.ResponseWriter, r *http.Request) {
	// 1. 새 키 쌍 생성
	privateKey, _ := generateKeys()

	// 2. 공개키를 16진수 문자열로 변환 (전송용)
    pubKeyBytes := privateKey.PublicKey.X.Bytes()
    publicKeyHex := hex.EncodeToString(pubKeyBytes)

	// 3. 테스트 메시지 생성
	msg := Message{
		Content:   "이것은 테스트 메시지입니다.",
		Timestamp: time.Now(),
	}
	msgBytes, _ := json.Marshal(msg)

	// 4. 메시지에 서명
	signature, err := sign(privateKey, msgBytes)
	if err != nil {
		http.Error(w, "서명 생성 실패", http.StatusInternalServerError)
		return
	}

	// 5. 서명된 메시지 객체 생성
	signedMsg := SignedMessage{
		Message:   msg,
		Signature: signature,
		PublicKey: publicKeyHex,
	}

	// 6. 결과를 JSON으로 클라이언트에게 반환
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(signedMsg)
}

func main() {
	// 핸들러 등록
	http.HandleFunc("/submit", handleSubmit)
	http.HandleFunc("/messages", handleGetMessages)
	http.HandleFunc("/sign-test", handleSignTest)

	fmt.Println("Web3 학습용 서버 시작 (포트: 8080)")
	fmt.Println("사용법:")
	fmt.Println("1. 브라우저나 curl로 'http://localhost:8080/sign-test'에 접속하여 서명된 메시지 샘플 확인")
	fmt.Println("2. 위 결과(JSON 전체)를 복사하여 '/submit' 엔드포인트에 POST 요청 전송")
	fmt.Println("3. 'http://localhost:8080/messages'에 접속하여 저장된 메시지 확인")

	// 서버 시작
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalf("서버 시작 실패: %v", err)
	}
}
