FROM ubuntu:19.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y --no-install-recommends --assume-yes software-properties-common && \
  add-apt-repository ppa:hwangsaeul/ppa && \
  apt-get update && \
  apt-get install -y --no-install-recommends --assume-yes debhelper meson libgstreamer1.0-dev libgstreamer-plugins-bad1.0-dev \
    libsrt-dev gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly git && rm -rf /var/lib/apt/lists/*;

COPY build-gaeguli.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/build-gaeguli.sh"]
