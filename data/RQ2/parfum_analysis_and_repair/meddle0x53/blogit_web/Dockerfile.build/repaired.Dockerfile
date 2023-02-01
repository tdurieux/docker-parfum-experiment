FROM elixir:1.5

MAINTAINER meddle <n.tzvetinov@gmail.com

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y --no-install-recommends -q install git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

ADD . /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only-prod

RUN npm install && npm cache clean --force;

RUN ./build_release.sh

CMD ["bash"]
