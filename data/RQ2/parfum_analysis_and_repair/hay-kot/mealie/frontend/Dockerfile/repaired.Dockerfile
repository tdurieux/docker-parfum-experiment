FROM node:16 as builder

WORKDIR /app

COPY . .

RUN yarn install \
  --prefer-offline \
  --frozen-lockfile \
  --non-interactive \
  --production=false \

  --network-timeout 1000000 && yarn cache clean;

RUN yarn build

RUN rm -rf node_modules && \
  NODE_ENV=production yarn install \
  --prefer-offline \
  --pure-lockfile \
  --non-interactive \
  --production=true && yarn cache clean;

FROM node:16-alpine

RUN apk add --no-cache caddy

WORKDIR /app

# copying caddy into image
COPY --from=builder /app  .
COPY ./Caddyfile /app/

ENV HOST 0.0.0.0
EXPOSE 3000

RUN chmod +x /app/run.sh
ENTRYPOINT /app/run.sh
