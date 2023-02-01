FROM node:12.18.3-buster AS builder

ARG SQUOOSH_VERSION=v1.12.0
WORKDIR /build

RUN set -xe \
    && apt install -y --no-install-recommends openssl \
    && adduser --disabled-password --gecos '' builder \
    && chown -R builder: /build && rm -rf /var/lib/apt/lists/*;

USER builder

RUN set -xe \
    && wget -qO- https://github.com/GoogleChromeLabs/squoosh/archive/${SQUOOSH_VERSION}.tar.gz | tar xz --strip 1 \
    && sed -i '/google-analytics.com/d' src/index.ts \
    && npm install \
    && npm run build && npm cache clean --force;

FROM node:12.18.3-alpine3.12
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ENV UID=791 GID=791

EXPOSE 8080
WORKDIR /squoosh

COPY --from=builder /build .
COPY s6.d /etc/s6.d
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache nginx \
    && npm rebuild node-sass \
    && mkdir -p /run/nginx \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

CMD ["run.sh"]
