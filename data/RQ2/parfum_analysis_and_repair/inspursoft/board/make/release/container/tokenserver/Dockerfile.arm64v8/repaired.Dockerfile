FROM arm64v8/alpine:3.8

MAINTAINER huay@inspur.com

ADD make/release/container/tokenserver/tokenserver /usr/bin/tokenserver

RUN chmod u+x /usr/bin/tokenserver

WORKDIR /usr/bin/

ENTRYPOINT ["/usr/bin/tokenserver"]

VOLUME ["/usr/bin"]

EXPOSE 4000