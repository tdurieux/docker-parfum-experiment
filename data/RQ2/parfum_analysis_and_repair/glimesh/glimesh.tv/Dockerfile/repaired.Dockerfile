# Doesn't use alpine because we need dart-sass to work and it needs glibc
FROM elixir:1.13.4 AS build

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

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

# workaround for janus npm install
RUN git config --global url."https://github.com".insteadOf ssh://git@github.com

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN mix assets.deploy

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM debian:bullseye-slim AS app
RUN apt-get update
RUN apt-get install -y --no-install-recommends libssl-dev libncurses-dev ca-certificates imagemagick librsvg2-bin npm && rm -rf /var/lib/apt/lists/*;

RUN npm install -g svgo && npm cache clean --force;

WORKDIR /app

RUN chown nobody:nogroup /app

USER nobody:nogroup

COPY --from=build --chown=nobody:nogroup /app/_build/prod/rel/glimesh ./

ENV HOME=/app

CMD ["bin/glimesh", "start"]
