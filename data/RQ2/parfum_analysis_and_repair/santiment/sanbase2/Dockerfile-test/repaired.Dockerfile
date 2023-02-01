FROM elixir:1.13.3-slim

RUN apt-get update -y && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN curl https://sh.rustup.rs -sSf | \
  sh -s -- --default-toolchain stable -y

ENV RUSTFLAGS="-C target-feature=-crt-static"

ENV PATH=/root/.cargo/bin:$PATH

RUN apt-get install --no-install-recommends -y make \
  g++ \
  git \
  postgresql-client \
  imagemagick \
  openssl \
  wget && rm -rf /var/lib/apt/lists/*;

ENV MIX_ENV test

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app

COPY mix.lock /app/mix.lock
COPY mix.exs /app/mix.exs

RUN mix deps.get
RUN mix deps.compile

COPY . /app
RUN mix format --check-formatted

CMD mix test --formatter Sanbase.FailedTestFormatter --formatter ExUnit.CLIFormatter --slowest 20
