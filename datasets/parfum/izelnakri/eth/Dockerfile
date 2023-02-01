FROM "elixir:1.12.3-slim"

ARG MIX_ENV=dev
ENV MIX_ENV=$MIX_ENV

WORKDIR /code

RUN apt-get update && apt-get -y install cargo python procps autoconf libtool libgmp3-dev git curl make build-essential && \
  curl https://get.volta.sh | bash

ENV PATH=$PATH:/root/.volta/bin

RUN volta install node@16.9

ADD ["package.json", "package-lock.json", "/code/"]

RUN npm install

ADD ["mix.lock", "mix.exs", "/code/"]

RUN echo "y" | mix local.hex --if-missing && echo "y" | mix local.rebar --if-missing

RUN mix deps.get && MIX_ENV=test mix deps.compile && \
  MIX_ENV=$MIX_ENV mix deps.compile && MIX_ENV=prod mix deps.compile

ADD ["config", "lib", "/code/"]

RUN MIX_ENV=$MIX_ENV mix compile

ADD ["test", "/code/"]

RUN MIX_ENV=test mix compile && MIX_ENV=$MIX_ENV mix compile

ADD . /code/

RUN MIX_ENV=test mix compile && MIX_ENV=$MIX_ENV mix compile

CMD ["/bin/bash"]
