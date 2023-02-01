FROM arm64v8/alpine
RUN apk add --no-cache netcat-openbsd curl

ARG WORKDIR=/usr/yunji/cloudiac/
WORKDIR ${WORKDIR}
COPY repos repos

