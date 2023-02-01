FROM node:12.3.1-alpine

ENV NODE_ENV production
ENTRYPOINT ["/docker-entrypoint"]

WORKDIR /sqlpad

COPY . .

RUN scripts/build.sh && \
    npm cache clean --force && \
    cp -r /sqlpad/server /usr/app && \
    cp /sqlpad/docker-entrypoint / && \
    chmod +x /docker-entrypoint && \
    rm -rf /sqlpad

WORKDIR /var/lib/sqlpad
