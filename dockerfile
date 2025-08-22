# node:18-alpine 이미지로 시작합니다.
FROM node:18-alpine

# 작업 디렉토리를 /app으로 설정합니다.
WORKDIR /app

# PocketBase 실행 파일을 복사합니다.
COPY pocketbase ./

# 앱이 사용할 포트를 외부에 노출합니다.
EXPOSE 8090

# PocketBase 서버를 실행합니다.
CMD ["./pocketbase", "serve", "--http", "0.0.0.0:8090"]