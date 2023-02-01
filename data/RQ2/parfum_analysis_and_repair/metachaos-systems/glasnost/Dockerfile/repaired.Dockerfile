FROM elixir:1.5.2

ENV DEBIAN_FRONTEND=noninteractive

ENV MIX_ENV prod
ENV PORT 80

RUN apt update
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ADD . /glasnost_app
WORKDIR /glasnost_app

RUN chmod +x start.sh

RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get --all

RUN mix compile

ENTRYPOINT ./start.sh
