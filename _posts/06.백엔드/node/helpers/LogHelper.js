// 1. 필요한 모듈 참조.
import dotenv from 'dotenv';
// $ yarn add winston winston-daily-rotate-file
import winston from 'winston';
import DailyRotateFile from 'winston-daily-rotate-file';

// 이 함수가 호출되는 순간 .env 파일의 내용이 process.env에 저장된다.
dotenv.config();

// 2. 로거(Logger) 생성
const logger = winston.createLogger({
    /**
     * 로그 레벨
     * - error: 0, warn: 1, info: 2, http: 3, verbose: 4, debug: 5, silly: 6
     * - level을 지정하면 해당 레벨 이하의 로그만 출력됨. (기본값: info)
     * - 개발 환경에서는 'debug'나 'silly'로 설정하여 모든 로그를 확인하고,
     *   운영 환경에서는 'info'나 'warn'으로 설정하여 필요한 로그만 기록하는 것이 일반적.
     */
    level: process.env.LOG_LEVEL?.toLowerCase() || 'debug',

    /**
     * 로그 출력 형식(Format) 설정
     * - winston.format.combine(): 여러 포맷을 조합하여 사용.
     */
    format: winston.format.combine(
        // 타임스탬프를 'YYYY-MM-DD HH:mm:ss' 형식으로 추가
        winston.format.timestamp({
            format: 'YYYY-MM-DD HH:mm:ss'
        }),
        // 에러 객체가 주어졌을 경우, 스택 트레이스를 포함하여 출력
        winston.format.errors({ stack: true }),
        // 로그 메시지를 printf 형식으로 커스터마이징
        winston.format.printf(({ timestamp, level, message, stack, ...meta }) => {
            // 만약 메타데이터(meta) 객체가 있다면, JSON 문자열로 변환하여 추가
            const metaString = Object.keys(meta).length ? ` ${JSON.stringify(meta)}` : '';
            // 에러 객체가 있다면 스택 트레이스를, 없다면 일반 메시지를 사용
            return `${timestamp} [${level.toUpperCase()}]: ${stack || message}${metaString}`;
        })
    ),

    /**
     * 로그 출력 대상(Transports) 설정
     * - 여러 개의 transport를 배열로 지정하여 로그를 다양한 곳으로 동시에 출력 가능.
     */
    transports: [
        // 1) 콘솔에 로그 출력
        new winston.transports.Console({
            // 콘솔 출력 시에는 색상을 입혀 가독성을 높일 수 있음.
            format: winston.format.combine(
                winston.format.colorize({ all: true }) // 모든 레벨에 색상 적용
            )
        }),

        // 2) 파일에 모든 레벨의 로그 저장 (일별 파일 생성)
        new DailyRotateFile({
            // 로그 파일명 형식. %DATE%는 날짜로 자동 치환됨.
            filename: `${process.env.LOG_PATH || 'logs'}/app-%DATE%.log`,
            datePattern: 'YYYY-MM-DD',      // 날짜 형식
            zippedArchive: true,            // 로그 파일이 생성된 후 이전 로그 파일을 압축할지 여부
            maxSize: '20m',                 // 로그 파일의 최대 크기
            maxFiles: '14d'                 // 로그 파일을 보관할 최대 일수 (14일)
        }),

        // 3) 에러 로그만 별도의 파일에 저장 (일별 파일 생성)
        new DailyRotateFile({
            level: 'error', // 'error' 레벨의 로그만 이 파일에 기록
            filename: `${process.env.LOG_PATH || 'logs'}/error-%DATE%.log`,
            datePattern: 'YYYY-MM-DD',
            zippedArchive: true,
            maxSize: '20m',
            maxFiles: '30d' // 에러 로그는 좀 더 길게 보관 (30일)
        })
    ]
});

// 생성한 로거 객체를 내보냄 (export)
// -> 이 객체를 require하여 애플리케이션의 다른 파일에서 사용 가능
export default logger;