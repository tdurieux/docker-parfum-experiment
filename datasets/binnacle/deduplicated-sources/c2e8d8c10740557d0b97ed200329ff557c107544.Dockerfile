FROM alpine:latest
LABEL maintainer="Francis Chuang <francis.chuang@boostport.com>"

RUN mkdir -p /kubernetes-vault

ADD kubernetes-vault /bin/kubernetes-vault
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]