FROM node:16 AS builder
WORKDIR /app

COPY api/package.json api/yarn.lock api/
RUN cd api; yarn install --frozen-lockfile && yarn cache clean;

COPY web/package.json web/yarn.lock web/
RUN cd web; yarn install --frozen-lockfile && yarn cache clean;

COPY api api
RUN cd api; yarn prisma generate
RUN cd api; yarn build

COPY web web
RUN cd web; yarn build

FROM node:16-alpine
WORKDIR /app

COPY api/package.json api/yarn.lock api/
RUN cd api; yarn install --frozen-lockfile --production && yarn cache clean;

COPY --from=builder /app/api/prisma ./api/prisma
COPY --from=builder /app/api/dist ./api/dist
COPY --from=builder /app/web/dist ./web/dist

EXPOSE 3000
ENV SERVE_STATIC_PATH "../web/dist"

CMD cd api; yarn prisma migrate deploy && yarn start:prod
