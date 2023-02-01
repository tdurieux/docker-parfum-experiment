ARG ELIXIR_VERSION="1.12"
FROM elixir:${ELIXIR_VERSION}

ARG PHOENIX_VERSION="1.5"

LABEL mantainer="Jonathan Gao <gsmlg.com@gmail.com>"

LABEL ELIXIR_VERSION="${ELIXIR_VERSION}"
LABEL PHOENIX_VERSION="${PHOENIX_VERSION}"

RUN apt-get update \
    && apt-get install --no-install-recommends -y figlet \
    && mix local.rebar --force \
    && mix local.hex --force \
    && mix archive.install --force hex phx_new ${PHOENIX_VERSION} && rm -rf /var/lib/apt/lists/*;


ENTRYPOINT ["/bin/bash"]
