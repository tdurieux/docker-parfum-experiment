FROM hexpm/elixir:1.13.4-erlang-25.0-ubuntu-focal-20211006

# Install debian packages
RUN apt-get update
RUN apt-get install --no-install-recommends --yes build-essential inotify-tools postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes git && rm -rf /var/lib/apt/lists/*;

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app