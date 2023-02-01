FROM alpine:3.7

RUN apk update && \
    apk add --no-cache bash bash-completion util-linux coreutils findutils grep e2fsprogs-extra

RUN mkdir /data
ADD bin/* /usr/local/bin/

ENTRYPOINT ["libri"]
