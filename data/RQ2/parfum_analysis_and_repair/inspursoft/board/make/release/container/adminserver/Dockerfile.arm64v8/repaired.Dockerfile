FROM arm64v8/alpine:3.8

RUN echo http://mirrors.ustc.edu.cn/alpine/v3.7/main > /etc/apk/repositories; \
echo http://mirrors.ustc.edu.cn/alpine/v3.7/community >> /etc/apk/repositories; \
apk add --no-cache openssh openssh-client openssl

ADD make/release/container/adminserver/adminserver /usr/bin/adminserver
COPY VERSION /usr/bin/VERSION

WORKDIR /usr/bin/

CMD ["adminserver"]

EXPOSE 8080