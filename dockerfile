# STEP 1: 빌드 환경 설정
# Node.js 18 기반의 경량 이미지를 사용합니다.
FROM node:18-alpine AS builder

# 작업 디렉토리를 /usr/src/app으로 설정합니다.
WORKDIR /usr/src/app

# 프로젝트의 모든 파일을 Docker 컨테이너로 복사합니다.
COPY . .

# 의존성 패키지를 설치합니다.
RUN npm install

# --- 핵심 수정 부분 ---
# Next.js 앱이 있는 폴더로 이동합니다.
# 당신의 Next.js 프로젝트 폴더 이름으로 교체해주세요. (예: ./app 또는 ./src)
WORKDIR /usr/src/app/app

# 빌드 명령어를 실행합니다.
RUN npm run build

# ---
# STEP 2: 실행 환경 설정
# 빌드된 앱을 실행할 가벼운 환경을 설정합니다.
FROM node:18-alpine

# 작업 디렉토리를 설정합니다.
WORKDIR /usr/src/app

# 빌드 환경에서 생성된 파일들을 최종 환경으로 복사합니다.
COPY --from=builder /usr/src/app/app/.next/standalone ./
COPY --from=builder /usr/src/app/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/app/public ./public

# 앱이 사용할 포트를 외부에 노출합니다.
EXPOSE 3000

# 앱을 실행하는 명령어를 지정합니다.
CMD ["node", "server.js"]