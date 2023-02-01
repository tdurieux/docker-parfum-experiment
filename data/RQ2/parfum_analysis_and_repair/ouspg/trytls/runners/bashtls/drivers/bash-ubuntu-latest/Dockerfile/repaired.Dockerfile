FROM ubuntu:latest

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  curl && rm -rf /var/lib/apt/lists/*;

CMD bash '/etc/shared/scripts/drive'
