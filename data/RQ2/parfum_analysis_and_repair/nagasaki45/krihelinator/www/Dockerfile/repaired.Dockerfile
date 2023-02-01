FROM elixir:1.5.2

RUN apt-get update && apt-get install --no-install-recommends -y inotify-tools && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/elixir/app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod
COPY mix.exs ./
COPY mix.lock ./
RUN mix do deps.get, deps.compile

COPY . ./

CMD ["mix", "phoenix.server"]
