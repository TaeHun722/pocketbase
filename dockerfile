# 베이스 이미지로 가벼운 Alpine Linux를 사용합니다.
FROM alpine:latest

# PocketBase 버전을 변수로 지정하여 쉽게 변경할 수 있도록 합니다.
ARG PB_VERSION=0.29.2

# 필요한 도구(curl, unzip)를 설치합니다.
RUN apk add --no-cache curl unzip

# 지정된 버전의 PocketBase를 다운로드하고 압축을 풉니다.
RUN curl -L https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip -o temp.zip
RUN unzip temp.zip
RUN rm temp.zip

# Railway가 외부 요청을 받을 수 있도록 8080 포트를 개방합니다.
EXPOSE 8080

# 컨테이너가 시작될 때 PocketBase 서버를 실행하는 명령어입니다.
CMD ["./pocketbase", "serve", "--http=0.0.0.0:8080"]