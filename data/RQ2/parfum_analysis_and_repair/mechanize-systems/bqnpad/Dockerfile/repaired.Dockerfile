FROM node:16.13.2-bullseye-slim AS build
RUN apt-get update -y && apt-get install --no-install-recommends -y watchman make && rm -rf /var/lib/apt/lists/*;
RUN npm install -g pnpm@6.32.3 && npm cache clean --force;

WORKDIR /app

COPY ./pnpm-lock.yaml /app/pnpm-lock.yaml
RUN pnpm fetch

COPY ./ /app
RUN pnpm install --offline

RUN pnpm build

FROM node:16.13.2-bullseye-slim AS runtime
RUN npm install -g pnpm@6.32.3 && npm cache clean --force;

WORKDIR /app

COPY ./pnpm-lock.yaml /app/pnpm-lock.yaml
RUN pnpm fetch --production

COPY ./ /app
RUN pnpm install --offline --production

COPY --from=build /app/node_modules/.cache/asap /app/node_modules/.cache/asap

ENV ASAP__INTERFACE="0.0.0.0"
ENV ASAP__PORT="8080"
ENTRYPOINT ["pnpm", "run", "start"]
