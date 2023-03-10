# build a production version of apps/frontend (including dependencies)
FROM node:16.13-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git

RUN mkdir -p apps/frontend packages/ui
COPY package.json package-lock.json ./
COPY apps/frontend/package.json ./apps/frontend/
COPY packages/ui/package.json ./packages/ui/
RUN set - x && npm ci

ENV NODE_ENV="production"

COPY turbo.json ./
COPY apps/frontend/ ./apps/frontend/
COPY packages/ui/ ./packages/ui/

RUN npx turbo run build \
    --scope="@klicker-uzh/frontend" \
    --include-dependencies \
    --no-deps


# build a runtime image of apps/frontend
FROM node:16.13-alpine AS runner

WORKDIR /app

RUN apk add --no-cache tini \
  && chown -R node:0 /app

USER node

COPY --from=builder /app/apps/frontend/next.config.mjs ./
COPY --from=builder /app/apps/frontend/public ./public
COPY --from=builder /app/apps/frontend/package.json ./package.json

COPY --from=builder --chown=node:0 /app/apps/frontend/.next/standalone ./
COPY --from=builder --chown=node:0 /app/apps/frontend/.next/static ./.next/static
COPY --from=builder --chown=node:0 /app/apps/frontend/src/klicker.conf.mjs ./
COPY --from=builder --chown=node:0 /app/apps/frontend/src/polyfills.mjs ./
COPY --from=builder --chown=node:0 /app/apps/frontend/src/server.mjs ./

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "server.mjs"]

LABEL maintainer="Roland Schlaefli <roland.schlaefli@bf.uzh.ch>"
LABEL name="@klicker-uzh/frontend"

EXPOSE 3000

HEALTHCHECK CMD [ curl -f https://localhost:3000/ || exit 1]

