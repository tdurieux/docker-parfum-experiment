FROM ubuntu:latest

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  lua5.1 \
  luarocks \
  openssl \
  libssl-dev \
  git && rm -rf /var/lib/apt/lists/*;

RUN luarocks install luasocket
RUN luarocks install luasec

CMD bash '/etc/shared/scripts/drive'
