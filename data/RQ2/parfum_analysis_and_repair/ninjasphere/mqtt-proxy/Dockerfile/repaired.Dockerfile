FROM       golang:1.4
MAINTAINER Ninja Blocks <developers@ninjablocks.com>

RUN apt-get -qy update && apt-get -qy --no-install-recommends install vim-common gcc mercurial bzr supervisor && rm -rf /var/lib/apt/lists/*;
RUN        mkdir -p /var/log/supervisor
RUN        mkdir -p /etc/mqtt-proxy

COPY etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY etc/example.config.toml /etc/mqtt-proxy/config.toml

COPY build/mqtt-proxy /app/
WORKDIR /app

EXPOSE     6300
CMD ["/usr/bin/supervisord"]