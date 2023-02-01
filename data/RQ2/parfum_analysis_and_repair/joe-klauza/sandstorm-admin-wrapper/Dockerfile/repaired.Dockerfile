FROM ruby:2.7-slim-buster


RUN apt-get update

# General dependencies
RUN apt-get install --no-install-recommends -y wget make gcc && rm -rf /var/lib/apt/lists/*;

# Install Steamcmd dependencies
RUN apt-get install --no-install-recommends -y lib32gcc1 && rm -rf /var/lib/apt/lists/*;

# Sandstorm server won't run under root
RUN useradd -ms /bin/bash sandstorm

USER sandstorm
WORKDIR /home/sandstorm

COPY --chown=sandstorm:sandstorm . .

RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN mv steamcmd_linux.tar.gz steamcmd/installation/
RUN cd steamcmd/installation && tar -xvf steamcmd_linux.tar.gz && rm steamcmd_linux.tar.gz
RUN rm steamcmd/installation/steamcmd_linux.tar.gz

# Add config for docker container

RUN cp config/config.toml.docker config/config.toml

RUN gem install bundler:1.17.2

WORKDIR /home/sandstorm/admin-interface

RUN /bin/bash -c bundle

WORKDIR /home/sandstorm

CMD ./docker_start.sh
