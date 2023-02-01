# Elixir + Phoenix

FROM hexpm/elixir:1.11.3-erlang-23.2.2-ubuntu-focal-20201008

# Install debian packages
RUN apt-get update && apt-get install --no-install-recommends --yes git build-essential inotify-tools postgresql-client lsof && rm -rf /var/lib/apt/lists/*;

# Install Elixir tools
RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app