FROM grapevinehaus/elixir:1.9.4-1 as builder

RUN mix local.rebar --force && \
    mix local.hex --force
WORKDIR /apps/socket/
ENV MIX_ENV=prod
COPY data/mix.* /apps/data/
COPY socket/mix.* /apps/socket/
RUN mix deps.get --only prod && \
  mix deps.compile

FROM builder as releaser
ENV MIX_ENV=prod
COPY data /apps/data/
COPY socket /apps/socket/
RUN mix release && \
  cd _build/prod/rel/grapevine_socket/ && \
  tar czf /opt/grapevine_socket.tar.gz .