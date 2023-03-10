FROM golang:1.17.5-alpine3.15

WORKDIR /matrixcube

RUN MAIN_VERSION=$(cat /etc/alpine-release | cut -d '.' -f 0-2) \
    && mv /etc/apk/repositories /etc/apk/repositories-bak \
    && { \
        echo "https://mirrors.aliyun.com/alpine/v${MAIN_VERSION}/main"; \
        echo "https://mirrors.aliyun.com/alpine/v${MAIN_VERSION}/community"; \
    } >> /etc/apk/repositories \
    && apk add --update --no-cache make \
    && apk add --update --no-cache gcc \
    && apk add --update --no-cache g++ \
    && apk add --update --no-cache bash

ENTRYPOINT ["/matrixcube/test_loop.sh"]