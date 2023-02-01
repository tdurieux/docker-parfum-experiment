FROM elixir:1.10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends --yes build-essential inotify-tools \
    && mix local.hex --force \
    && mix local.rebar --force && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
