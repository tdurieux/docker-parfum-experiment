FROM node:alpine AS builder

COPY / /Minyami/

WORKDIR /Minyami

RUN npm i -g typescript && npm ci && tsc && \
    npm pack && \
    mv minyami-`node -p "require('./package.json').version"`.tgz minyami.tgz && npm cache clean --force;


FROM node:alpine

COPY --from=builder /Minyami/minyami.tgz /minyami.tgz

RUN apk add --no-cache dumb-init mkvtoolnix && \
    npm i -g minyami.tgz && npm cache clean --force;

VOLUME /minyami

WORKDIR /minyami

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["minyami", "--help"]
