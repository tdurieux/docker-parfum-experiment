FROM node:16.15.1-bullseye-slim AS assets

LABEL maintainer="Nick Janetakis <nick.janetakis@gmail.com>"

WORKDIR /app/assets

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && mkdir -p /node_modules && chown node:node -R /node_modules /app

USER node

COPY --chown=node:node assets/package.json assets/*yarn* ./

RUN yarn install && yarn cache clean

ARG NODE_ENV="production"
ENV NODE_ENV="${NODE_ENV}" \
    PATH="${PATH}:/node_modules/.bin" \
    USER="node"

COPY --chown=node:node . ..

RUN if [ "${NODE_ENV}" != "development" ]; then \
  ../run yarn:build:js && ../run yarn:build:css; else mkdir -p /app/priv/static; fi

###############################################################################

FROM elixir:1.13.4-slim AS dev
LABEL maintainer="Nick Janetakis <nick.janetakis@gmail.com>"

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl inotify-tools \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd --create-home elixir \
  && mkdir -p /mix && chown elixir:elixir -R /mix /app

USER elixir

RUN mix local.hex --force && mix local.rebar --force

ARG MIX_ENV="prod"
ENV MIX_ENV="${MIX_ENV}" \
    USER="elixir"

COPY --chown=elixir:elixir mix.* ./
RUN if [ "${MIX_ENV}" = "dev" ]; then \
  mix deps.get; else mix deps.get --only "${MIX_ENV}"; fi

COPY --chown=elixir:elixir config/config.exs config/"${MIX_ENV}".exs config/
RUN mix deps.compile

COPY --chown=elixir:elixir --from=assets /app/priv/static /public
COPY --chown=elixir:elixir . .

RUN if [ "${MIX_ENV}" != "dev" ]; then \
  ln -s /public /app/priv/static \
    && mix phx.digest && mix release && rm -rf /app/priv/static; fi

ENTRYPOINT ["/app/bin/docker-entrypoint-web"]

EXPOSE 8000

CMD ["iex", "-S", "mix", "phx.server"]

###############################################################################

FROM elixir:1.13.4-slim AS prod
LABEL maintainer="Nick Janetakis <nick.janetakis@gmail.com>"

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd --create-home elixir \
  && chown elixir:elixir -R /app

USER elixir

ENV USER=elixir

COPY --chown=elixir:elixir --from=dev /public /public
COPY --chown=elixir:elixir --from=dev /mix/_build/prod/rel/hello ./
COPY --chown=elixir:elixir bin/docker-entrypoint-web bin/

ENTRYPOINT ["/app/bin/docker-entrypoint-web"]

EXPOSE 8000

CMD ["bin/hello", "start"]
