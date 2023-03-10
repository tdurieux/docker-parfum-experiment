FROM node:carbon-alpine
MAINTAINER butlerx <butlerx@notthe.cloud>
ENV NODE_ENV development
RUN apk add --no-cache --update git python build-base && \
    mkdir -p /usr/src/app /usr/src/cp-translations /usr/src/cp-zen-frontend && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY docker-entrypoint.sh /usr/src
VOLUME /usr/src/app /usr/src/cp-translations /usr/src/cp-zen-frontend
EXPOSE 8000
CMD ["/usr/src/docker-entrypoint.sh"]
