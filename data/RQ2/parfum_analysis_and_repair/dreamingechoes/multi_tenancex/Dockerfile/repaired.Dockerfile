# Versions
#
# Erlang: 1:21.0
# Elixir: 1.7.2
# Phoenix: 1.3.4

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

# Elixir requires UTF-8
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y sudo wget curl inotify-tools git build-essential zip unzip bcrypt && rm -rf /var/lib/apt/lists/*;

# Download and install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm i npm@latest -g && npm cache clean --force;

# Download and install Erlang package
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
  && dpkg -i erlang-solutions_1.0_all.deb \
  && apt-get update

ENV ERLANG_VERSION 1:21.0

# Install Erlang
RUN apt-get install --no-install-recommends -y esl-erlang=$ERLANG_VERSION && rm erlang-solutions_1.0_all.deb && rm -rf /var/lib/apt/lists/*;

ENV ELIXIR_VERSION 1.7.2

# Install Elixir
RUN mkdir /opt/elixir \
  && cd /opt/elixir \
  && curl -f -O -L https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR_VERSION/Precompiled.zip \
  && unzip Precompiled.zip \
  && cd /usr/local/bin \
  && ln -s /opt/elixir/bin/elixir \
  && ln -s /opt/elixir/bin/elixirc \
  && ln -s /opt/elixir/bin/iex \
  && ln -s /opt/elixir/bin/mix

ENV PHOENIX_VERSION 1.3.4

# Install the Phoenix Mix archive
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-$PHOENIX_VERSION.ez

# Install hex & rebar
RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix hex.info

WORKDIR /multi_tenancex
