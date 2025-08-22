# 베이스 이미지로 가벼운 Alpine Linux의 특정 버전을 사용합니다.
# 'latest' 대신 특정 버전을 사용하면 예측 가능한 빌드를 보장합니다.
FROM alpine:3.18

# PocketBase 버전을 변수로 지정하여 쉽게 변경할 수 있도록 합니다.
ARG PB_VERSION=0.29.2

# 앱 소스를 저장할 작업 디렉토리를 설정합니다.
# 이렇게 하면 루트 디렉토리(/)가 깨끗하게 유지됩니다.
WORKDIR /app

# 필요한 도구(curl, unzip)를 설치합니다.
# --no-cache 옵션으로 이미지 크기를 최소화합니다.
RUN apk add --no-cache curl unzip

# 지정된 버전의 PocketBase를 다운로드하고 압축을 풉니다.
RUN curl -L https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip -o temp.zip \
    && unzip temp.zip \
    && rm temp.zip

# 컨테이너가 외부 요청을 받을 수 있도록 8080 포트를 개방합니다.
EXPOSE 8080

# 컨테이너가 시작될 때 PocketBase 서버를 실행합니다.
# "--http=0.0.0.0:8080" 명령어로 컨테이너 내부의 모든 네트워크 인터페이스에 바인딩합니다.
CMD ["./pocketbase", "serve", "--http=0.0.0.0:8080"]