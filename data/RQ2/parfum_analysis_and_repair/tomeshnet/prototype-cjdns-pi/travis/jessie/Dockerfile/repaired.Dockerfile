FROM resin/rpi-raspbian:jessie

COPY qemu-arm-static /usr/bin/qemu-arm-static
RUN apt-get update \
  && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;