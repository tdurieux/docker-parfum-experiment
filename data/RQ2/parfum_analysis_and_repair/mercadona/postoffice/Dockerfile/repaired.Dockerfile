# BUILD
FROM elixir:1.11.2-alpine as build

RUN apk add --no-cache --update make g++ nodejs npm

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV prod

WORKDIR /app

COPY . .

RUN mix deps.get --only prod && npm run deploy --prefix ./assets && mix phx.digest && mix release --quiet

# RELEASE