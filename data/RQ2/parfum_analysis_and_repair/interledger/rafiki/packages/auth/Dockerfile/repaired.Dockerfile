FROM node:14-slim as builder

WORKDIR /workspace

RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY manifests ./
RUN yarn install --immutable && yarn cache clean;

COPY packs ./

CMD ["node", "./packages/auth/dist/index.js"]
