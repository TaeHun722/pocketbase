# STEP 1: 빌드 환경 설정
FROM node:18-alpine AS builder

# 작업 디렉토리를 /app으로 설정합니다.
WORKDIR /app

# package.json과 lock 파일을 복사합니다.
COPY package*.json ./

# 의존성 패키지를 설치합니다.
RUN npm install

# 모든 소스 코드를 복사합니다.
COPY . .

# Next.js 앱을 프로덕션 빌드합니다.
RUN npm run build

# ---
# STEP 2: 실행 환경 설정
FROM node:18-alpine

# 작업 디렉토리를 /app으로 설정합니다.
WORKDIR /app

# 빌드 환경에서 생성된 파일들을 최종 환경으로 복사합니다.
# Next.js는 .next/standalone에 실행 가능한 서버를 생성합니다.
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
# PocketBase 실행 파일도 복사해야 합니다.
COPY --from=builder /app/pocketbase ./pocketbase

# 앱이 사용할 포트를 외부에 노출합니다.
EXPOSE 3000

# 앱 실행 (Next.js) 및 PocketBase 실행
CMD ["sh", "-c", "npm start & ./pocketbase serve --http 0.0.0.0:8090"]