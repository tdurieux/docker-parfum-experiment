FROM aeons/erlang:20.2 as elixir
LABEL maintainer="Bjørn Madsen <bm@aeons.dk>"

ENV ELIXIR_VERSION 1.7.2

RUN apk --no-cache add --virtual build-dependencies wget ca-certificates && \
    wget --no-check-certificate https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip && \
    mkdir -p /opt/elixir-${ELIXIR_VERSION}/ && \
    unzip Precompiled.zip -d /opt/elixir-${ELIXIR_VERSION}/ && \
    rm Precompiled.zip && \
    apk del build-dependencies && \
    rm -rf /etc/ssl

RUN apk --update upgrade && \
  apk add --no-cache docker erlang-xmerl make && \
  rm -rf /var/cache/apk/*

COPY . /build

ARG APP
ENV MIX_ENV prod

WORKDIR /build

RUN mix deps.get --only prod
RUN mix compile
RUN echo y | mix release.clean --implode
RUN mix release

WORKDIR /build
