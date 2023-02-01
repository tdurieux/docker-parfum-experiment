FROM elixir:1.11.4 as builder

WORKDIR /app

# Install hex
RUN mix local.hex --force && \
mix local.rebar --force && \
mix hex.info

# Pass --build-arg BUILD_ENV=dev to build a dev image
ARG BUILD_ENV=prod

ENV MIX_ENV=$BUILD_ENV

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Add all the rest
ADD . .

# Build and release
RUN mix do compile, release

# Note: it is important to keep Debian versions in sync, or incompatibilities between libcrypto will happen
FROM debian:stretch-slim

WORKDIR /app

RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install libssl1.1 && rm -rf /var/lib/apt/lists/*; # Set the locale
ENV LANG C.UTF-8

# We need SSL


# We have to redefine this here since it goes out of scope for each build stage
ARG BUILD_ENV=prod

COPY --from=builder /app/_build/$BUILD_ENV/rel/astarte_export .

CMD ["sh", "-c", "./bin/astarte_export export ${REALM} ${OUTPUT_XML_FILE}"]
