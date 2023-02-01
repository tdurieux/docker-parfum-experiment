FROM arm64v8/alpine
RUN apk add --no-cache netcat-openbsd curl docker-cli

ARG WORKDIR=/usr/yunji/cloudiac/
WORKDIR ${WORKDIR}

