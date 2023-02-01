#
# base
#
FROM bitwalker/alpine-elixir-phoenix:1.4.2 as base

ENV \
    HOME=/opt/app/ \
    TERM=xterm \
    MIX_ENV=prod \
    REPLACE_OS_VARS=true \
    SHELL=/bin/sh

WORKDIR /opt/app

#
# build
#
FROM base as builder

#
# unfortunately, python is needed to run node-sass
RUN \
    echo "@edge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk --no-cache --update add python && \
    rm -rf /var/cache/apk/*

RUN npm install -g yarn

RUN mkdir -p \
    config \
    apps/db/config \
    apps/gatherer/config \
    apps/graph/config \
    apps/mkm_api/config \
    apps/admin/config \
    apps/mse_logging/config \
    apps/proxy/config \
    apps/mse_web/config \
    apps/mtgjson/config \
    apps/workers/config

# Cache elixir deps
COPY mix.exs mix.lock         ./
COPY apps/db/mix.exs          apps/db/
COPY apps/gatherer/mix.exs    apps/gatherer/
COPY apps/graph/mix.exs       apps/graph/
COPY apps/mkm_api/mix.exs     apps/mkm_api/
COPY apps/admin/mix.exs       apps/admin/
COPY apps/mse_logging/mix.exs apps/mse_logging/
COPY apps/proxy/mix.exs       apps/proxy/
COPY apps/mse_web/mix.exs     apps/mse_web/
COPY apps/mtgjson/mix.exs     apps/mtgjson/
COPY apps/workers/mix.exs     apps/workers/
RUN mix deps.get

# Cache elixir deps compilation
COPY apps/db/config/*          apps/db/config/
COPY apps/gatherer/config/*    apps/gatherer/config/
COPY apps/graph/config/*       apps/graph/config/
COPY apps/mkm_api/config/*     apps/mkm_api/config/
COPY apps/admin/config/*       apps/admin/config/
COPY apps/mse_logging/config/* apps/mse_logging/config/
COPY apps/mse_web/config/*     apps/mse_web/config/
COPY apps/proxy/config/*       apps/proxy/config/
COPY apps/mtgjson/config/*     apps/mtgjson/config/
COPY apps/workers/config/*     apps/workers/config/
COPY config/* config/
RUN mix deps.compile

# Compile admin app assets
COPY apps/admin apps/admin
RUN cd apps/admin/assets && yarn install
RUN cd apps/admin/assets && ./node_modules/.bin/brunch build --production
RUN cd apps/admin && mix phx.digest

# Cache yarn packages
COPY apps/frontend/package.json apps/frontend/
COPY apps/frontend/yarn.lock apps/frontend/
RUN cd apps/frontend && yarn install

# Compile frontend app assets
COPY apps/frontend apps/frontend
COPY apps/mse_web apps/mse_web
RUN cd apps/frontend && ./node_modules/.bin/brunch build --production
RUN cd apps/mse_web  &&  mix phx.digest

COPY rel rel
COPY apps apps

RUN mix release --env=prod

#
# RELEASE
#
FROM base as release

COPY --from=builder /opt/app/_build/prod/rel/mse ./

ENTRYPOINT ["/opt/app/bin/mse"]
