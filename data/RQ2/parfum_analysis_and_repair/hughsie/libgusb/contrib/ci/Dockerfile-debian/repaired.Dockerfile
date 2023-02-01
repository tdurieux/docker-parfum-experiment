FROM debian:buster

RUN echo "deb-src http://deb.debian.org/debian/ buster main" >> /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -yq --no-install-recommends meson && rm -rf /var/lib/apt/lists/*;
RUN apt-get build-dep --allow-unauthenticated -yq libgusb

RUN mkdir /build
WORKDIR /build
