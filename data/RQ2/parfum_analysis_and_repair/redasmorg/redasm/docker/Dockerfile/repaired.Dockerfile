FROM ubuntu:18.04

MAINTAINER bongartz@klimlive.de

RUN apt update \
; apt install --no-install-recommends -y \
  qt5-qmake \
  qt5-default \
  qtwebengine5-dev \
  libqt5webenginewidgets5 \
  cmake \
  g++ \
  git && rm -rf /var/lib/apt/lists/*;

COPY ./nightly-entrypoint.sh /

ENTRYPOINT ["/nightly-entrypoint.sh"]
