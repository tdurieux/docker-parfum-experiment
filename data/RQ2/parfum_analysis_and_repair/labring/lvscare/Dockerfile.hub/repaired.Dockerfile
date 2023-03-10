FROM alpine:latest
MAINTAINER "louisehong <louisehong4168@gmail.com>"

ENTRYPOINT ["/usr/bin/lvscare"]

ARG TARGETPLATFORM
WORKDIR /usr/bin/

RUN --mount=target=/build tar xf /build/dist/lvscare_*_$(echo ${TARGETPLATFORM} | tr '/' '_' | sed -e 's/arm_/arm/').tar.gz && rm /build/dist/lvscare_*_$( echo ${TARGETPLATFORM} | tr '/' '_' | sed -e 's/arm_/arm/').tar.gz

CMD ["--help"]
