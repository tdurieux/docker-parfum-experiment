# Define what version of Elixir to use - ATTENTION: when changing Elixir version
# make sure to update the `ALPINE_VERSION` arg to match,
# as well as the Elixir version in:
# - mix.exs
# - .github/workflows/test.yaml or .gitlab-ci.yml
# - Dockerfile.dev
# - .tool-versions
ARG ELIXIR_IMAGE=1.13-alpine

# The version of Alpine to use for the final image
# This should match the version of Alpine that the current elixir & erlang images (in Step 1) use.
# To find this you need to:
# 1. Locate the dockerfile for the elixir image matching the version, and check what erlang version it uses
#    e.g. https://github.com/erlef/docker-elixir/blob/master/1.13/otp-25-alpine/Dockerfile
# 2. Locate the corresponding dockerfile for the erlang version used, and check what alpine version it uses, and then copy that number into the ARG below:
#    e.g. https://github.com/erlang/docker-erlang-otp/blob/master/25/alpine/Dockerfile
ARG ALPINE_VERSION=3.16

# The following are build arguments used to change variable parts of the image, they should be set as env variables.
# The name of your application/release (required)
ARG APP_NAME
# The version of the application we are building (required)
ARG APP_VSN
ARG FLAVOUR
ARG FLAVOUR_PATH

#### STEP 1 - Build our app
FROM elixir:${ELIXIR_IMAGE} as builder

ENV HOME=/opt/app/ TERM=xterm MIX_ENV=prod APP_NAME=$APP_NAME FLAVOUR=$FLAVOUR FLAVOUR_PATH=./
WORKDIR $HOME

# necessary utils
RUN apk add --no-cache tar curl git rust cargo npm yarn bash

# dependencies for comeonin
RUN apk add --no-cache make gcc libc-dev

# Cache elixir deps
COPY mix.exs mess.exs mix.lock ./
# sometimes mix tries to read the config
RUN mkdir -p ./config
COPY data/current_flavour/config/config_basics.exs ./config/config.exs

# get deps from hex.pm
COPY data/current_flavour/config/deps.hex ./config/
RUN mix do local.hex --force, local.rebar --force
RUN mix do deps.get --only prod

# Compile initial hex deps, only if we're not using forks (warning: this makes the assumption that no Bonfire extensions are coming from Hex. otherwise this should be done only after copying config)
RUN if [ "$FORKS_TO_COPY_PATH" = "data/null" ] ; then MIX_ENV=prod mix do deps.compile ; else echo "Skip" ; fi

# add git deps (typically Bonfire extensions)
COPY data/current_flavour/config/deps.git ./config/

# fetch them because we need them for the non-configurable paths in config/deps_hooks.js
RUN mix do deps.get --only prod

# we need config before compiling Bonfire extensions
COPY data/current_flavour/config/ ./config/

# Optionally include local forks
ARG FORKS_TO_COPY_PATH
RUN if [ "$FORKS_TO_COPY_PATH" = "data/null" ] ; then rm ./config/deps.path ; else echo "Include locally forked extensions." ; fi
COPY ${FORKS_TO_COPY_PATH} ./forks/

# Update Bonfire extensions to latest git version (mostly useful in CI, and temporary: eventually we want to rely on version numbers and lockfile)
# RUN mix do bonfire.deps.update

# Fetch git deps (should be after forks are copied and updates are fetched, in case a forked/updated extension specified any different deps)
RUN mix do deps.get --only prod

# Include translations
COPY priv/localisation/ priv/localisation/
RUN ls -la priv/localisation/

# Compile remaining deps
RUN MIX_ENV=prod mix do deps.compile

# JS package manager
# RUN npm install -g pnpm
# install JS deps
COPY assets/package.json assets/*.sh ./assets/
# COPY assets/pnpm-lock.yaml ./assets/
COPY assets/yarn.lock ./assets/
COPY priv/*.sh ./priv/
RUN chmod +x assets/*.sh && sh assets/install.sh
RUN chmod +x config/*.sh && chmod +x priv/*.sh && sh config/deps.js.sh

# Update mime types
RUN MIX_ENV=prod mix do deps.clean --build mime

# Include migrations
COPY data/current_flavour/repo priv/repo

# bonfire-app code & assets
COPY lib lib
COPY assets assets
# COPY . .

# include an archive of the source code
COPY LICENSE ./
RUN mkdir -p priv/static/ && tar --exclude=*.env --exclude=assets/node_modules --exclude=assets/static/data -czvf priv/static/source.tar.gz lib deps assets config priv/repo mix.exs mix.lock mess.exs LICENSE && rm priv/static/source.tar.gz

# prepare static assets
COPY data/current_flavour/config/deps_hooks.js data/current_flavour/config/deps_hooks.js
RUN mix assets.build
RUN MIX_ENV=prod CI=1 mix phx.digest

# build final OTP release
RUN MIX_ENV=prod CI=1 mix release

##### STEP 2 - Prepare the server image
# From this line onwards, we're in a new image, which will be the image used in production
FROM alpine:${ALPINE_VERSION}

# The name of your application/release (required)
ARG APP_NAME
ARG APP_VSN
ARG APP_BUILD

ENV APP_NAME=${APP_NAME} APP_VSN=${APP_VSN} APP_REVISION=${APP_VSN}-${APP_BUILD}

# Essentials
RUN apk add --update --no-cache \
  mailcap \
  ca-certificates \
  openssh-client \
  openssl-dev \
  # ^ for HTTPS
  git \ 
  build-base \ 
  # ^ required by tree_magic 
  tzdata \
  gettext \
  # ^ localisation
  imagemagick \
  vips-tools \
  # ^ image resizing
  bash \
  curl
  #^ misc

WORKDIR /opt/app

# copy app build
COPY --from=builder /opt/app/_build/prod/rel/bonfire /opt/app

# start
CMD ["./bin/bonfire", "start"]
