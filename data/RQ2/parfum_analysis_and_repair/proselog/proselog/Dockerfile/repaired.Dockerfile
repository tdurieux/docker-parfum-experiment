##### BASE
FROM node:16-bullseye-slim as base

# install open ssl for prisma
RUN apt-get update && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;

RUN npm i -g pnpm && npm cache clean --force;

##### DEPS
FROM base as deps

WORKDIR /app

ADD . .

RUN pnpm i

##### BUILD
FROM deps as build

WORKDIR /app

COPY --from=deps /app /app

ENV NEXT_TELEMETRY_DISABLED 1
ENV NODE_ENV production
ENV BUILD_STEP=1
RUN pnpm build

##### FINAL
FROM base

ENV NODE_ENV=production
WORKDIR /app

COPY --from=build /app/.next/standalone /app
COPY --from=build /app/public /app/public
COPY --from=build /app/.next/static /app/.next/static

CMD ["pnpm", "start"]

