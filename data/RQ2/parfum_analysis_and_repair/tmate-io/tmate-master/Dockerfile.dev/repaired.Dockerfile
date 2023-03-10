FROM elixir:1.9-alpine

RUN mix local.hex --force && mix local.rebar --force
RUN apk --no-cache add git inotify-tools npm

WORKDIR /src/tmate-master

COPY mix.exs .
COPY mix.lock .

ARG MIX_ENV=dev
ENV MIX_ENV ${MIX_ENV}

RUN mix deps.get
RUN mix deps.compile

COPY assets/package-lock.json assets/package-lock.json
COPY assets/package.json assets/package.json
RUN cd assets && npm install && npm cache clean --force;

COPY assets assets
COPY config config
COPY lib lib
COPY priv/gettext priv/gettext
COPY priv/repo priv/repo

RUN mix compile

CMD mkfifo console; sleep 1000d > console & cat console | \
  iex --name master@master \
      --cookie cookie \
      --erl '-kernel inet_dist_listen_min 20000' \
      --erl '-kernel inet_dist_listen_max 20000' \
      -S mix phx.server
