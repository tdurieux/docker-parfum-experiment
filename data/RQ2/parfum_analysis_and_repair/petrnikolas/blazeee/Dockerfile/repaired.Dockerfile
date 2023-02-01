FROM voidlock/elixir:1.1

# install psql
RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

# install mix and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# configure work directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# install dependencies
COPY mix.* /usr/src/app/
COPY config /usr/src/app/
RUN mix do deps.get, deps.compile

CMD ["mix", "phoenix.server"]