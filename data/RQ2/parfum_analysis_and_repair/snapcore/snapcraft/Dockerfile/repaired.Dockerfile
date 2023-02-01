FROM ubuntu:xenial

RUN apt-get update && \
  apt-get dist-upgrade --yes && \
  apt-get install --no-install-recommends --yes \
  git \
  snapcraft \
  && \
  apt-get autoclean --yes && \
  apt-get clean --yes && rm -rf /var/lib/apt/lists/*;

# Required by click.
ENV LC_ALL C.UTF-8
ENV SNAPCRAFT_SETUP_CORE 1
