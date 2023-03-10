FROM node:16.15.0-alpine3.14

WORKDIR /usr/src

RUN npm install -g pnpm@7 && npm cache clean --force;

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/api/package.json apps/api/package.json

RUN pnpm config set store-dir .pnpm-store
RUN pnpm install --frozen-lockfile --ignore-scripts

CMD ["sh", "-c", "pnpm run -C apps/api dev"]
