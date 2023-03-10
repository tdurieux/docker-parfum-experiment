FROM grapevinehaus/elixir:1.9.4-1 as builder

RUN mix local.rebar --force && \
    mix local.hex --force
WORKDIR /apps/telnet
ENV MIX_ENV=prod
COPY telnet/mix.* /apps/telnet/
RUN mix deps.get --only prod && \
  mix deps.compile

FROM builder as releaser
ENV MIX_ENV=prod
COPY telnet /apps/telnet/
RUN mix release && \
  cd _build/prod/rel/telnet/ && \
  tar czf /opt/telnet.tar.gz .