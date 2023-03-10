ARG BASE_IMAGE_ALPINE
ARG SDK_TAG
FROM wicked.sdk:${SDK_TAG} as node-sdk

FROM ${BASE_IMAGE_ALPINE}

RUN addgroup -S -g 888 wicked && adduser -S -G wicked -u 888 wicked \
    && set -x \
    && apk add --no-cache \
        openssl \
        git \
        bash \
        dumb-init \
        su-exec \
        jq \
    && mkdir -p /usr/src/portal-env /usr/src/app \
    && chown -R wicked:wicked /usr/src \
    && mkdir -p /home/wicked \
    && chown -R wicked:wicked /home/wicked && rm -rf /usr/src/portal-env

USER wicked
COPY . /usr/src/portal-env
COPY package.all.json /usr/src/app/package.json
COPY --from=node-sdk /wicked-sdk.tgz /usr/src/app/wicked-sdk.tgz
COPY forever.sh /usr/src/app/forever.sh
COPY git_* /usr/src/app/

WORKDIR /usr/src/app
RUN cd ../portal-env \
    && npm pack \
    && mv portal-env-* ../portal-env.tgz \
    && cd /usr/src/app \
    && npm install --production && npm cache clean --force;

# We install all node_modules in this base image; no need to do it later
ONBUILD RUN date -u "+%Y-%m-%d %H:%M:%S" > /usr/src/app/build_date
ONBUILD COPY . /usr/src/app

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["./forever.sh", "npm", "start" ]
