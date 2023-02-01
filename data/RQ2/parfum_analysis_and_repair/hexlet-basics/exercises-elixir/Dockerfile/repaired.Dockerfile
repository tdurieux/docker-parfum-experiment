FROM hexletbasics/base-image:latest

WORKDIR /exercises-elixir

RUN apt-get update && \
    apt-get install --no-install-recommends -yq erlang elixir && rm -rf /var/lib/apt/lists/*;

ADD mix.* ./
RUN mix local.hex --force \
  && mix local.rebar --force \
  && mix hex.info
RUN mix deps.get

COPY . .

ENV PATH /exercises-elixir/bin:$PATH
