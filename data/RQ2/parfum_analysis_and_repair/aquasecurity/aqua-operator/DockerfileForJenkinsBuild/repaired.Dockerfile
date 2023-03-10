FROM golang:1.17-alpine

RUN apk update && apk add --no-cache git docker sudo make bash gcc musl-dev

RUN wget https://github.com/operator-framework/operator-sdk/releases/download/v1.20.0/operator-sdk_linux_amd64 && \
        chmod +x operator-sdk_linux_amd64 && sudo mv operator-sdk_linux_amd64 /usr/local/bin/operator-sdk