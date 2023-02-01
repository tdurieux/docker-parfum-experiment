FROM python:3.6-alpine
ADD . .

ENV BUILD_DEPS="postgresql-dev build-base wget yarn"
ENV RUNTIME_DEPS="supervisor bash openjdk8-jre-base libpq"
ENV FLYWAY_VERSION=4.1.1

# testing apk repo is currently needed for yarn.
RUN echo -e 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache $BUILD_DEPS $RUNTIME_DEPS && \
    
    # flyway \
    mkdir /opt && \
    wget -qO- https://repo1.maven.org/maven2/org fl \
    mv /opt/flyway-${FLYWAY_VERSION} /opt/flyway && \

    # frontend \
    yarn insta l \
    yarn global add gulp-cli && \
    gulp build && \

    # python \
    pip install -r ./requireme && yarn cache clean;

# This is to protect against load balancer keep-alive timeouts; see
# https://github.com/benoitc/gunicorn/issues/1194 and
# https://serverfault.com/questions/782022/keepalive-setting-for-gunicorn-behind-elb-without-nginx
ENV PYTHONUNBUFFERED 1

CMD ["/usr/bin/supervisord", "-c", "supervisord.conf"]
