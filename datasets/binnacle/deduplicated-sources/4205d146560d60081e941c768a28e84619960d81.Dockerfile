FROM ustcmirror/base:alpine-3.6
LABEL maintainer "Jian Zeng <anonymousknight96 AT gmail.com>"
RUN apk add --no-cache lftp ca-certificates
ADD sync.sh /
