# Extend from the official Elixir image.
FROM elixir:latest

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex package manager.
# By using `--force`, we don’t need to type “Y” to confirm the installation.
RUN mix local.hex --force

# Install rebar3 dependency
RUN wget https://repo.hex.pm/installs/1.13.0/rebar3
RUN mix local.rebar rebar3 ./rebar3 --force

# Install dependencies.
RUN HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix deps.get --force

# Compile the project.
RUN mix do compile

# Entrypoint
EXPOSE 5000
ENTRYPOINT ["mix", "phx.server"]
