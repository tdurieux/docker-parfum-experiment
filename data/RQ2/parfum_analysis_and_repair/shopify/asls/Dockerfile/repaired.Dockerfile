FROM elixir:1.10-slim as builder

RUN apt-get -qq update
RUN apt-get -qq -y --no-install-recommends install git build-essential python && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info

ENV MIX_ENV prod

ADD . .
RUN mix deps.get
RUN mix release --overwrite

FROM debian:buster-slim

RUN apt-get -qq update
RUN apt-get -qq -y --no-install-recommends install locales libssl1.1 libtinfo5 xdg-utils && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/asls .

CMD ["./bin/asls", "start"]
