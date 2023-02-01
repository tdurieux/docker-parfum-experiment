FROM circleci/elixir:1.8-node

USER root

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y ffmpeg && ffmpeg -version \
    && apt-get install -y curl && curl --version \
    && apt-get install -y make && make --version \
    && rm -rf /var/lib/apt/lists/*

RUN mix do local.rebar --force, local.hex --force
