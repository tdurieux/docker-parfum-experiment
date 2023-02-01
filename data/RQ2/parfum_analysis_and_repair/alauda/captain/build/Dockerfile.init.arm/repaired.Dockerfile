FROM arm64v8/alpine:3.11

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && apk upgrade --update-cache --available && \
    apk add --no-cache openssl && \
    rm -rf /var/cache/apk/*

COPY generate_certificate.sh /

COPY ./bin/kubectl /usr/local/bin/kubectl
