FROM alpine:3.8

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache bash \
	bash-doc \
	bash-completion \
	&& rm -rf /var/cache/apk/* \
	&& /bin/bash

RUN apk add --no-cache ca-certificates

WORKDIR /root

COPY build/cmd/gvite/gvite-*-linux/gvite .
COPY ./conf conf
COPY ./conf/node_config.json .

EXPOSE 8483 8484 48132 41420 8483/udp
ENTRYPOINT ["./gvite"] 