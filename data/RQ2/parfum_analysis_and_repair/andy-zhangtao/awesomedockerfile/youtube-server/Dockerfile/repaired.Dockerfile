FROM alpine:latest

RUN apk update && \
    apk add --no-cache -y py-pip libc6-compat ca-certificates wget openssl && \
    update-ca-certificates && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --pre youtube_dl_server

RUN mkdir /lib64 && \
    ln -s /lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

EXPOSE 9191

CMD ["/usr/bin/youtube-dl-server","--number-processes","50","--host","0.0.0.0"]