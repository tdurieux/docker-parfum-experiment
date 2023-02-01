ARG ALPINE_VERSION=edge

FROM alpine:$ALPINE_VERSION

LABEL authors="hoatle <hoatle@teracy.com>"

# add more arguments from CI to the image so that `$ env` should reveal more info
ARG CI_BUILD_ID
ARG CI_BUILD_REF
ARG CI_REGISTRY_IMAGE
ARG CI_BUILD_TIME

ENV CI_BUILD_ID=$CI_BUILD_ID CI_BUILD_REF=$CI_BUILD_REF CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE \
  CI_BUILD_TIME=$CI_BUILD_TIME

# thanks to: https://github.com/mvertes/docker-alpine-mongo/blob/master/Dockerfile

RUN \
  echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/main' >> /etc/apk/repositories && \
  echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories && \
  apk update && \
  apk add --no-cache mongodb

RUN mongo --version

VOLUME /data/db

EXPOSE 27017 28017

COPY run.sh /root

ENTRYPOINT ["/root/run.sh"]

CMD ["mongod"]
