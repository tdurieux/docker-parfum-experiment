FROM node:14-slim as builder

WORKDIR /workspace

RUN apt update && apt install --no-install-recommends -y curl xz-utils && rm -rf /var/lib/apt/lists/*;

COPY manifests ./
RUN yarn install --immutable && yarn cache clean;

COPY packs ./

CMD ["node", "./packages/backend/dist/index.js"]
