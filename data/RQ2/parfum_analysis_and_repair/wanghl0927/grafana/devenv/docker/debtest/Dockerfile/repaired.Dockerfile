FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

ADD *.deb /tmp/

