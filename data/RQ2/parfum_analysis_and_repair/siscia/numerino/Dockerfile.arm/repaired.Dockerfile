FROM armv7/armhf-ubuntu:14.04.3

MAINTAINER Simone Mosciatti

RUN apt-get -q update && \
    apt-get install --no-install-recommends -qy wget locales && rm -rf /var/lib/apt/lists/*;

RUN locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN wget https://packages.erlang-solutions.com/erlang/elixir/FLAVOUR_2_download/elixir_1.1.1-1~raspbian~wheezy_armhf.deb

RUN echo "deb http://packages.erlang-solutions.com/debian wheezy contrib" >> /etc/apt/sources.list

RUN wget https://packages.erlang-solutions.com/debian/erlang_solutions.asc && \
    apt-key add erlang_solutions.asc

RUN apt-get -q update && \
    apt-get install --no-install-recommends -qy erlang elixir && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -qy ssh git openssl ca-certificates && rm -rf /var/lib/apt/lists/*;

ENV REFRESHED_AT v0.1.7

RUN git clone https://github.com/siscia/numerino.git numerino

WORKDIR /numerino

RUN git checkout v0.1.7

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix deps.get

RUN mix compile

EXPOSE 4000

EXPOSE 4369

EXPOSE 5000

