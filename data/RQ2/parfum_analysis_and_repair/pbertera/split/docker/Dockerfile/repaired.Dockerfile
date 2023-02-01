FROM alpine:latest

ENV VER 1.1.3
ENV SPLIT_SRC https://github.com/pbertera/SPLiT/archive/${VER}.tar.gz

RUN apk update && apk add --no-cache python bash curl

RUN mkdir /opt && cd /opt && curl -f -L -k ${SPLIT_SRC} | tar xzvf -
WORKDIR /opt/SPLiT-${VER}

ADD wrapper.sh /opt/SPLiT-${VER}/

ENTRYPOINT ["./wrapper.sh"]

