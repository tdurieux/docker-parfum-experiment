FROM docker:1.12.2

MAINTAINER Dmitry Drozdov, https://github.com/ddrozdov

RUN apk add --update python py-pip bash && rm -rf /var/cache/apk/*

ARG version

RUN pip install --no-cache-dir docker-compose-swarm-mode==$version

ENTRYPOINT ["docker-compose-swarm-mode"]
