FROM openjdk:8u181-jdk-alpine

RUN apk add gcompat

ENV LD_PRELOAD=/lib/libgcompat.so.0

RUN apk add --no-cache tini
RUN apk add gcompat
ENV LD_PRELOAD=/lib/libgcompat.so.0

WORKDIR /server/target

COPY dockerize-alpine-linux-amd64-v0.6.1.tar.gz /server/target/dockerize-alpine-linux-amd64-v0.6.1.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-v0.6.1.tar.gz \
    && rm dockerize-alpine-linux-amd64-v0.6.1.tar.gz

COPY build/libs/kun-infra-0.1.jar /server/target/kun-infra.jar
EXPOSE 8088

ADD docker-entrypoint.sh /
RUN chmod +x  /docker-entrypoint.sh

ENV APP_CONFIG_ENV local
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]