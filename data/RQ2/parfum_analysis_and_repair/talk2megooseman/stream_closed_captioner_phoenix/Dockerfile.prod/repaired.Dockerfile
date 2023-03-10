FROM elixir:1.11.2-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python3

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# assets -- copy asset files so purgecss doesnt remove css files
COPY lib/stream_closed_captioner_phoenix_web/live/ lib/stream_closed_captioner_phoenix_web/live/
COPY lib/stream_closed_captioner_phoenix_web/templates/ lib/stream_closed_captioner_phoenix_web/templates/
COPY lib/stream_closed_captioner_phoenix_web/views/ lib/stream_closed_captioner_phoenix_web/views/

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/stream_closed_captioner_phoenix ./

ENV HOME=/app

CMD ["bin/stream_closed_captioner_phoenix", "start"]