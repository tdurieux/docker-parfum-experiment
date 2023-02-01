FROM alpine:latest

ENV UID=1337 \
    GID=1337

RUN echo "@edge_community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk add --no-cache su-exec ca-certificates olm@edge_community

ARG EXECUTABLE=./matrix-skype
COPY $EXECUTABLE /usr/bin/matrix-skype
COPY ./example-config.yaml /opt/matrix-skype/example-config.yaml
COPY ./docker-run.sh /docker-run.sh
VOLUME /data

CMD ["/docker-run.sh"]