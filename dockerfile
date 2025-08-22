# STEP 1: 빌드 환경 설정
FROM node:18-alpine AS builder

# 프로젝트의 루트 디렉토리
WORKDIR /usr/src/app

# 패키지 파일과 소스 코드를 복사합니다.
# 이 단계가 핵심입니다.
COPY package*.json ./
COPY . .

# 의존성 패키지들을 설치합니다.
RUN npm install

# Next.js 앱이 있는 'app' 디렉토리로 작업 경로를 변경하고 빌드합니다.
WORKDIR /usr/src/app/app
RUN npm run build

# ---
# STEP 2: 실행 환경 설정
FROM node:18-alpine

# 실행 디렉토리로 /usr/src/app/app/build 를 설정합니다.
WORKDIR /usr/src/app/app/build

# 빌드 환경에서 생성된 파일들을 최종 환경으로 복사합니다.
COPY --from=builder /usr/src/app/app/.next/standalone ./
COPY --from=builder /usr/src/app/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/app/public ./public

# 앱이 사용할 포트를 외부에 노출합니다.
EXPOSE 3000

# 앱을 실행하는 명령어를 지정합니다.
CMD ["node", "server.js"]