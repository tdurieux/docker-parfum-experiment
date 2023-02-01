###
### Builder Stage
###
FROM elixir:1.13-alpine AS builder

RUN apk update --no-cache \
  && apk add --no-cache build-base openssh git

WORKDIR /app

RUN mix local.hex --force \
  && mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY lib lib
RUN mix compile --warnings-as-errors

COPY priv priv
COPY assets assets
RUN mix assets.deploy

COPY config/runtime.exs config/
COPY rel rel
RUN mix release

###
### Final Stage - Separate image to keep it smaller
###