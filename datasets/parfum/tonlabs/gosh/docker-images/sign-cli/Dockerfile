# syntax=docker/dockerfile:1.4

FROM --platform=${BUILDPLATFORM} node:slim as base


FROM base as builder

WORKDIR /app
COPY . /app
RUN <<EOF
    set -e
    npm ci
    npm i -g typescript
    tsc
    find . -name '*.ts' -type f -delete
    find . -name '*.js.map' -type f -delete
    find . -name '*.d.ts' -type f -delete
    find . -name '*.d.ts.map' -type f -delete
    rm -rf node_modules
    rm -f tsconfig.tsbuildinfo
    NODE_ENV=production npm ci
EOF


FROM base
ENV NODE_ENV=production
RUN apt-get update -yq && apt-get install ca-certificates -yq

WORKDIR /app
COPY --from=builder /app/ .
ENTRYPOINT [ "node", "cli" ]
CMD [ "--help" ]
