# STEP 1: 빌드 환경 설정
# node:18-alpine 이미지로 시작합니다.
FROM node:18-alpine AS builder

# 앱의 작업 디렉토리를 /usr/src/app으로 설정합니다.
WORKDIR /usr/src/app

# 중요한 package.json 파일을 먼저 복사하여 의존성 캐싱을 활용합니다.
COPY ./app/package*.json ./app/

# 의존성을 설치합니다.
RUN npm install --prefix ./app/

# 모든 소스 코드를 복사합니다.
COPY . .

# Next.js 앱이 있는 'app' 디렉토리로 작업 경로를 변경하고 빌드합니다.
WORKDIR /usr/src/app/app
RUN npm run build

# ---
# STEP 2: 실행 환경 설정
# 빌드된 앱을 실행할 가벼운 환경을 설정합니다.
FROM node:18-alpine

# 작업 디렉토리를 설정합니다.
WORKDIR /usr/src/app

# 빌드 환경에서 생성된 파일들을 최종 환경으로 복사합니다.
COPY --from=builder /usr/src/app/app/.next/standalone ./app/.next/standalone
COPY --from=builder /usr/src/app/app/node_modules ./app/node_modules
COPY --from=builder /usr/src/app/app/public ./app/public

# 포트 노출
EXPOSE 3000

# 앱 실행
CMD ["node", "./app/.next/standalone/server.js"]