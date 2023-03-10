###
### Fist Stage - Building the Release
###
FROM hexpm/elixir:1.13.4-erlang-25.0.2-alpine-3.14.6 AS build

# install build dependencies
RUN apk add --no-cache build-base npm git gcompat

# prepare build dir
WORKDIR /app

# extend hex timeout
ENV HEX_HTTP_TIMEOUT=20

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV as prod
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey

# Copy over the mix.exs and mix.lock files to load the dependencies. If those
# files don't change, then we don't keep re-fetching and rebuilding the deps.
COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only prod && \
    mix deps.compile

# install npm dependencies
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets

# NOTE: If using TailwindCSS, it uses a special "purge" step and that requires
# the code in `lib` to see what is being used. Uncomment that here before
# running the npm deploy script if that's the case.
COPY lib lib

# build assets
RUN mix assets.deploy

# copy source here if not using TailwindCSS
# COPY lib lib

# compile and build release
COPY rel rel
RUN mix do compile, release

###
### Second Stage - Setup the Runtime Environment
###

# prepare release docker image