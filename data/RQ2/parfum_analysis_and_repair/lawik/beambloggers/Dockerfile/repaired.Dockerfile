FROM elixir:1.10.4 AS build

# install build dependencies
RUN curl -f -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y build-essential nodejs && rm -rf /var/lib/apt/lists/*;

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod SECRET_KEY_BASE="gMG5ncoLVAnCKHWSHMVKmvU0Cgju+ZqLbvRYm8OD3H9e9rgnR1rvh2oYyywbdncv"
# prep mix
COPY mix.exs mix.lock ./
COPY config config
# install mix dependencies
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

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
FROM debian:buster-slim AS app
RUN apt-get update && apt-get install --no-install-recommends -y openssl libncursesw6 && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

#COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/webring ./
COPY --from=build /app/_build/prod/rel/webring ./

ENV HOME=/app

CMD ["bin/webring", "start"]