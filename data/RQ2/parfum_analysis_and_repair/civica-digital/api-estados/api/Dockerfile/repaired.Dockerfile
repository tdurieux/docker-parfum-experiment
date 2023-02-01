FROM elixir:1.3.2

ENV DEBIAN_FRONTEND=noninteractive

RUN mix local.hex --force

RUN mix local.rebar --force

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
ADD . /app

RUN mix do deps.get, compile
