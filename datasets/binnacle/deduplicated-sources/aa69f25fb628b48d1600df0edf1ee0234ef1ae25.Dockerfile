# Dockerfile

FROM pottava/golang:1.5
MAINTAINER pottava

RUN go get -u github.com/justinas/alice

LABEL jp.co.supinf.works.application="golang-microservices-webui" \
      jp.co.supinf.works.license="MIT"
