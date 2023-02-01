FROM elixir:1.11.4 as builder

RUN apt-get -qq update
RUN apt-get -qq -y --no-install-recommends install git build-essential curl && rm -rf /var/lib/apt/lists/*;

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info

WORKDIR /app
ENV MIX_ENV prod
ADD . .
RUN mix deps.get
RUN mix release

# Note: it is important to keep Debian versions in sync, or incompatibilities between libcrypto will happen
FROM debian:stretch-slim
RUN apt-get -qq update

# Set the locale
ENV LANG C.UTF-8

# We need SSL
RUN apt-get -qq -y --no-install-recommends install libssl1.1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/astarte_import .

CMD ["sh", "-c", "./bin/astarte_import import ${REALM} ${XML_FILE}"]
