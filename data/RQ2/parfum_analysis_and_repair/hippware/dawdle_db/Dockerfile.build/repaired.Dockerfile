FROM hippware/alpine-elixir-dev:1.9.4

ENV MIX_ENV=test

# Cache elixir deps
COPY mix.exs mix.lock ./

RUN mix deps.get && \
    mix deps.compile && \
    # mix dialyzer --plt && \
    mix deps.compile

COPY .check.exs .credo.exs .formatter.exs ./
COPY . .

RUN mix compile