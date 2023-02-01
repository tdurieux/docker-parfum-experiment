FROM elixir:1.5
RUN apt-get update && apt-get install --no-install-recommends -y inotify-tools && rm -rf /var/lib/apt/lists/*;
WORKDIR /elixir-koans
ADD . /elixir-koans/
RUN mix local.hex --force
RUN mix deps.get
CMD mix meditate
