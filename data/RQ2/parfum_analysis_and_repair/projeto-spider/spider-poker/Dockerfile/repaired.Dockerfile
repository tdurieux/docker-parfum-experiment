FROM elixir:1.4
RUN apt-get update && apt-get install --no-install-recommends -y inotify-tools && rm -rf /var/lib/apt/lists/*;
RUN mix local.rebar --force
RUN mix local.hex --force
ADD . /code
WORKDIR /code
RUN mix deps.get
RUN mix compile
CMD mix phx.server
