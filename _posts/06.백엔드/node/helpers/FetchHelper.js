import logHelper from './LogHelper.js';

const fetchHelper = {
    __setUrl: function (url) {
        if (url.constructor !== URL) {
            return new URL(url);
        }
        return url;
    },
    __request: async function (url, method = "get", params = null, headers = {}) {
        // 요청 URL이 URL객체가 아닌 경우 객체 생성
        url = this.__setUrl(url);

        // post, put, delete 방식에서 파라미터가 FormData 객체가 아닌 경우 객체 변환
        if (method.toLocaleLowerCase() !== "get" && params) {

            if (headers?.["Content-Type"] === "application/json") {
                params = JSON.stringify(params);
            } else {
                if (params.constructor !== FormData) {
                    const tmp = structuredClone(params);
                    params = new FormData();

                    for (const t in tmp) {
                        const value = tmp[t];
                        if (value) {
                            params.set(t, value);
                        }
                    }
                }
            }
        }

        let result = null;      // Ajax 연동 결과가 저장될 객체
        let options = null;     // post, put, delete에서 사용할 옵션 변수

        if (method.toLocaleLowerCase() !== "get") {
            options = {
                method: method,
                cache: "no-cache",
                headers: headers,
                body: params,
            };
        }

        try {
            // 백엔드로부터의 응답 받기
            const response = await fetch(url, options);
            logHelper.http(`Request [${method.toUpperCase()}][${response.status}-${response.statusText}] ${url}`);

            // 백엔드가 에러를 보내왔다면?
            if (parseInt(response.status / 100) != 2) {
                let message = response.statusText;
                let json = await response.json();

                if (!message) {
                    message = json?.message ?? "서버에서 에러가 발생했습니다.";
                }

                // 에러 객체 생성후 에러 발생 --> catch로 이동함
                const err = new Error(message);
                err.status = response.status;
                throw err;
            }

            // 응답으로부터 JSON 데이터 추출
            result = await response.json();
        } catch (err) {
            logHelper.error("FetchHelper Request Error", err);
            throw err;
        }

        return result;
    },
    get: async function(urlString, params, headers = {}) {
        let url = this.__setUrl(urlString);

        // params를 url에 QueryString형태로 추가해야 함
        if (params) {
            if (params.constructor === FormData) {
                for (const p of params.keys()) {
                    const value = params.get(p);
                    if (value) {
                        url.searchParams.set(p, value);
                    }
                }
            } else {
                for (const p in params) {
                    const value = params[p];
                    if (value) {
                        url.searchParams.set(p, params[p]);
                    }
                }
            }
        }

        return await this.__request(url, "get", null, headers);
    },
    post: async function(urlString, params, headers = {}) {
        // params를 FormData객체 형태로 변환해야 함
        return await this.__request(urlString, "post", params, headers);
    },
    put: async function(urlString, params, headers = {}) {
        // params를 FormData객체 형태로 변환해야 함
        return await this.__request(urlString, "put", params, headers);
    },
    delete: async function(urlString, params, headers = {}) {
        // params를 FormData객체 형태로 변환해야 함
        return await this.__request(urlString, "delete", params, headers);
    }
}

export default fetchHelper;