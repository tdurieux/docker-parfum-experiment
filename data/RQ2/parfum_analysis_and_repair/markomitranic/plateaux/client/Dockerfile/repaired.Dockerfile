FROM node:10.24-slim AS base

WORKDIR /app
USER root
RUN apt-get update && apt-get install --no-install-recommends -y \
    make g++ python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g gulp && npm cache clean --force;
COPY scripts/entrypoint.sh /app/scripts/entrypoint.sh
ENTRYPOINT ["/app/scripts/entrypoint.sh"]

FROM base AS prod
COPY ./ /app/