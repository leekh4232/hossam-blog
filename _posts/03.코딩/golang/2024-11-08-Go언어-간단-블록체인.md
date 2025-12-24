---
title: "Go 언어로 만드는 간단한 블록체인 (쉬운 설명)"
description: "블록체인의 기초 개념을 비유와 예시로 쉽게 설명하고, Go 언어로 간단한 블록체인을 구현하는 방법을 정리함."
categories: [03.Coding,Golang]
date:   2024-11-08 12:02:00 +0900
author: Hossam
image: /images/indexs/golang.webp
tags: [Programming,Golang,Blockchain,SHA256,Learning]
pin: false
math: true
mermaid: true
---

# Go 언어로 만드는 간단한 블록체인 (쉬운 설명)

블록체인은 **데이터를 안전하게 이어 붙이는 기술**임.
하나의 블록 안에 데이터(예: 거래 내역)가 들어 있고, 이 블록들이 줄줄이 연결되어 있음.
연결할 때 "해시(hash)"라는 특별한 도장을 찍어 두기 때문에, 중간에 데이터를 바꾸면 금방 들통남.

비유하자면:

- 블록 = 공책 한 장
- 해시 = 공책 페이지 번호 + 앞 장의 서명
- 체인 = 공책 전체

누가 중간 장을 찢거나 내용을 고치면, 페이지 번호와 서명이 안 맞아서 바로 티가 남음.

## 간단한 블록체인 구현 실습

### 1단계: 블록과 체인을 위한 구조체 정의하기

- **Block**: 한 개의 데이터 단위임. (시간, 내용, 이전 블록 해시, 현재 블록 해시 포함)
- **Blockchain**: 여러 블록을 줄줄이 담아둔 것임. (슬라이스로 관리)

👉 첫 번째 블록은 제네시스 블록(Genesis Block)이라 함.
   시작점이기 때문에 이전 블록 해시는 비워둠.

**실습 파일: `15-간단-블록체인/main.go (step-1)`**

```go
package main

import (
    "crypto/sha256"
    "encoding/hex"
    "fmt"
    "strconv"
    "time"
)

/** 1. 블록과 체인을 위한 구조체 정의하기 */
type Block struct {
    Timestamp     int64  // 만든 시간
    Data          string // 담을 데이터
    PrevBlockHash []byte // 이전 블록 해시
    Hash          []byte // 현재 블록 해시
}

// 블록체인 구조체 정의
type Blockchain struct {
    blocks []*Block
}

// 블록의 해시 계산 함수
func (b *Block) SetHash() {
    timestamp := []byte(strconv.FormatInt(b.Timestamp, 10))
    headers := append(b.PrevBlockHash, append([]byte(b.Data), timestamp...)...)
    hash := sha256.Sum256(headers)
    b.Hash = hash[:]
}

// 새 블록 생성 함수
func NewBlock(data string, prevBlockHash []byte) *Block {
    block := &Block{time.Now().Unix(), data, prevBlockHash, []byte{}}
    block.SetHash()
    return block
}

// 블록체인 생성 (제네시스 블록 포함)
func NewBlockchain() *Blockchain {
    genesisBlock := NewBlock("Genesis Block", []byte{})
    return &Blockchain{[]*Block{genesisBlock}}
}

/******** main() *********/
func main() {
    // 새 블록체인 생성
    bc := NewBlockchain()
}
```

여기서 해시는 **데이터의 지문 같은 것**임.
데이터+시간+이전 블록 해시 → SHA-256 함수 → 해시 값이 나옴.
내용이 1글자라도 바뀌면 해시 값이 완전히 달라짐.

---

### 2단계: 블록 추가하기

블록체인은 계속 이어지는 구조임.
새 블록을 추가할 때는 **바로 직전 블록의 해시**를 가져와서 자기 `PrevBlockHash`에 넣음.

비유:
- 새로운 공책 페이지를 붙일 때, 앞 장에 있던 서명을 그대로 가져와 자기 장에도 적는 것임.
- 그러면 순서가 보장되고, 중간에 뭔가 바뀌면 연결고리가 깨짐.

**실습 파일: `15-간단-블록체인/main.go (step-2)`**

```go
/** 1. 블록과 체인을 위한 구조체 정의하기 */

// ... 기존 코드 유지

/** 2. 블록 추가하기 */
func (bc *Blockchain) AddBlock(data string) {
    prevBlock := bc.blocks[len(bc.blocks)-1]
    newBlock := NewBlock(data, prevBlock.Hash)
    bc.blocks = append(bc.blocks, newBlock)
}

/******** main() *********/
func main() {
    // 새 블록체인 생성
    bc := NewBlockchain()

    // 블록 추가
    bc.AddBlock("Send 1 BTC to Alice")
    bc.AddBlock("Send 2 BTC to Bob")

    // 블록 출력
    for _, block := range bc.blocks {
        fmt.Printf("Prev. hash: %s\n", hex.EncodeToString(block.PrevBlockHash))
		fmt.Printf("Time: %d\n", block.Timestamp)
		fmt.Printf("Data: %s\n", block.Data)
		fmt.Printf("Hash: %s\n", hex.EncodeToString(block.Hash))
        fmt.Println("----------------------------------")
    }
}
```

---

### 3단계: 블록체인 검증하기

중요한 건, **블록체인이 믿을 수 있는지 확인**하는 것임.
검증 방법은 단순함:

1. 현재 블록의 해시를 다시 계산 → 저장된 해시랑 맞는지 비교
   (데이터가 중간에 바뀌면 값이 달라짐)
2. 현재 블록이 기억하는 `PrevBlockHash`가 진짜 이전 블록의 해시랑 같은지 확인

이 두 가지가 모두 맞아야 블록체인이 올바름.

**실습 파일: `15-간단-블록체인/main.go (step-3)`**

```go
/** 1. 블록과 체인을 위한 구조체 정의하기 */

// ... 기존 코드 유지

/** 2. 블록 추가하기 */

// ... 기존 코드 유지

/** 3. 블록체인 검증하기 */
func (bc *Blockchain) IsChainValid() bool {
    for i := 1; i < len(bc.blocks); i++ {
        currentBlock := bc.blocks[i]
        prevBlock := bc.blocks[i-1]

        tempHash := currentBlock.Hash
        currentBlock.SetHash()
        if string(currentBlock.Hash) != string(tempHash) {
            return false
        }
        currentBlock.Hash = tempHash

        if string(currentBlock.PrevBlockHash) != string(prevBlock.Hash) {
            return false
        }
    }
    return true
}

/******** main() *********/
func main() {
    // 새 블록체인 생성
    bc := NewBlockchain()

    // 블록 추가
    bc.AddBlock("Send 1 BTC to Alice")
    bc.AddBlock("Send 2 BTC to Bob")

    // 블록 출력
    for _, block := range bc.blocks {
        fmt.Printf("Prev. hash: %s\n", hex.EncodeToString(block.PrevBlockHash))
		fmt.Printf("Time: %d\n", block.Timestamp)
		fmt.Printf("Data: %s\n", block.Data)
		fmt.Printf("Hash: %s\n", hex.EncodeToString(block.Hash))
        fmt.Println("----------------------------------")
    }

    // 체인 검증
    if bc.IsChainValid() {
        fmt.Println("✅ 블록체인 무결성 검증 성공!")
    } else {
        fmt.Println("❌ 블록체인 무결성 검증 실패!")
    }
}
```

---

### 블록체인 실습을 통해 알 수 있는 핵심

- 블록은 데이터와 해시로 연결됨
- 해시 덕분에 중간에 데이터가 바뀌면 금방 들통남
- 실제 암호화폐 블록체인은 여기에 작업증명(Proof-of-Work), 네트워크, 지갑 등 복잡한 기능이 더해짐

### 블록 체인 기술을 이커머스에 활용하는 방안

블록체인은 데이터 위조를 막는 기술이므로 이커머스에서 발생하는 거래·리뷰·상품 이력 같은 데이터를 신뢰성 있게 관리하는 데 적합함.

| 적용 영역         | 활용 아이디어                            | 기대 효과                       |
| ------------- | ---------------------------------- | --------------------------- |
| **거래 내역 기록**  | 주문, 결제, 환불 내역을 블록체인에 기록            | 위·변조 불가능한 거래 장부 확보 → 신뢰성 강화 |
| **리뷰 관리**     | 상품 리뷰를 블록체인에 저장                    | 조작/삭제 방지 → 고객 후기 신뢰도 상승     |
| **재고 관리**     | 상품 입출고 기록을 블록체인에 연결                | 투명한 물류 흐름 추적, 재고 부정 방지      |
| **상품 이력 추적**  | 원산지, 제조 과정, 유통 과정을 블록체인에 기록        | 정품 인증 및 공급망 투명성 확보          |
| **포인트·쿠폰 관리** | 적립금·쿠폰 발급 및 사용 이력을 블록체인에 기록        | 중복 사용, 부정 사용 방지             |
| **회원 인증**     | 블록체인 기반 DID(탈중앙 신원 인증) 적용          | 개인정보 유출 위험 감소, 간편한 로그인 가능   |
| **정품 인증**     | 명품, 한정판 상품 구매 시 고유 블록체인 토큰(NFT) 발급 | 위조품 방지, 재판매 시 신뢰성 보장        |
| **파트너 정산**    | 판매자/제휴사와 매출 정산 내역을 블록체인으로 관리       | 투명한 수익 배분, 분쟁 최소화           |


## 블록 체인과 전자지갑

### 블록체인 네트워크의 이해

여러 대의 컴퓨터(노드)가 서로 연결되어, 같은 장부(블록체인)를 공유하는 시스템

즉, 한두 대의 서버가 관리하는 게 아니라, 전 세계 수많은 컴퓨터가 똑같은 사본을 가지고 있음.

👉 **비유:**
```
학교에서 시험을 보는데, 시험지를 한 선생님만 보관한다면 그 선생님이 고치면 아무도 모름.
근데 학생 전원이 같은 시험지 사본을 가지고 있으면, 누군가 내용을 고치려 하면 금방 들통남.
```

#### 블록체인 네트워크의 구성요소

| 개념                | 설명                          | 비유                             |
| ----------------- | --------------------------- | ------------------------------ |
| **노드(Node)**      | 블록체인에 참여하는 컴퓨터              | 시험지를 가진 학생                     |
| **P2P 통신**        | 중앙 서버 없이 서로 직접 연결해 데이터 공유   | 학생들끼리 직접 시험지 비교                |
| **합의(Consensus)** | 어떤 거래가 진짜인지 다수의 노드가 동의하는 과정 | 반 전체가 “이 답안이 맞다”라고 손 들어 찬성하는 것 |

#### 블록체인 네트워크의 특징

1. 중앙 관리자 없음 → 은행 같은 기관이 없어도 거래 기록 가능
2. 분산 저장 → 한두 대가 고장 나도 장부는 계속 유지
3. 투명성 → 누구나 거래 내역을 확인할 수 있음
4. 보안성 → 데이터를 위조하려면 네트워크 참여자 대부분을 속여야 함 (현실적으로 어려움)



### 전자지갑(Digital Wallet)의 이해

블록체인 네트워크에서 **내 자산(코인, 토큰, NFT 등)**을 관리하는 도구임.

돈을 직접 담는 게 아니라, **“내가 이 주소의 주인이다”**라는 권한(=개인 키)을 관리하는 것임.

👉 비유:
- 블록체인 = 은행 시스템 전체
- 블록 = 거래 내역이 적힌 장부 페이지
- 전자지갑 = 내 은행 계좌 번호(공개 키) + 계좌 비밀번호(개인 키)를 담은 앱

#### 전자지갑의 구성 요소

| 개념 | 설명 | 비유 |
|------|------|------|
| **공개 키 (Public Key)** | 누구나 볼 수 있는 주소. 코인을 받을 때 사용 | 은행 계좌 번호 |
| **개인 키 (Private Key)** | 내 자산을 조작할 수 있는 비밀 키. 유출되면 끝 | 계좌 비밀번호 |
| **지갑 주소 (Wallet Address)** | 공개 키에서 파생된 짧은 주소 | 계좌 번호 요약본 |
| **전자서명 (Digital Signature)** | 개인 키로 거래를 승인하는 과정 | 계좌 비밀번호로 송금 승인 |


#### 블록체인과 전자지갑의 관계

1. 블록체인은 **거래가 기록되는 장부**임.
2. 전자지갑은 **내 주소와 서명을 관리하는 도구**임.
3. 실제 거래 데이터에는
   - 보낸 사람 주소 (공개 키)
   - 받는 사람 주소 (공개 키)
   - 보낸 사람의 서명 (개인 키 기반)
   이 들어가고, 블록체인이 이를 기록함.