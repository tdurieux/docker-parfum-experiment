FROM python:3.7.9-alpine3.12

ARG VERSION
ENV VERSION master

ARG URLCONTEXT

ENV uid 1337
ENV gid 1337
ENV user lemur
ENV group lemur

RUN addgroup -S ${group} -g ${gid} && \
    adduser -D -S ${user} -G ${group} -u ${uid} && \
    apk --update --no-cache add python3 libldap postgresql-client nginx supervisor curl tzdata openssl bash && \
    apk --update --no-cache add --virtual build-dependencies \
                git \
                tar \
                curl \
                python3-dev \
                npm \
                bash \
                musl-dev \
                cargo \
                gcc \
                autoconf \
                automake \
                libtool \
                make \
                nasm \
                zlib-dev \
                postgresql-dev \
                libressl-dev \
                libffi-dev \
                cyrus-sasl-dev \
                openldap-dev && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir --upgrade setuptools && \
    mkdir -p /home/lemur/.lemur/ && \
    mkdir -p /run/nginx/ /etc/nginx/ssl/

COPY ./ /opt/lemur   
WORKDIR /opt/lemur

RUN chown -R $user:$group /opt/lemur/ /home/lemur/.lemur/ && \
    npm install --unsafe-perm && \
    pip3 install --no-cache-dir -e . && \
    node_modules/.bin/gulp build && \
    node_modules/.bin/gulp package --urlContextPath=${URLCONTEXT} && \
    apk del build-dependencies && npm cache clean --force;

COPY docker/entrypoint /
COPY docker/src/lemur.conf.py /home/lemur/.lemur/lemur.conf.py
COPY docker/supervisor.conf /
COPY docker/nginx/default.conf /etc/nginx/conf.d/
COPY docker/nginx/default-ssl.conf /etc/nginx/conf.d/

RUN chmod +x /entrypoint
WORKDIR /

HEALTHCHECK --interval=12s --timeout=12s --start-period=30s \  
 CMD curl --fail http://localhost:80/api/1/healthcheck | grep -q ok || exit 1

USER root

ENTRYPOINT ["/entrypoint"]

CMD ["/usr/bin/supervisord","-c","supervisor.conf"]
