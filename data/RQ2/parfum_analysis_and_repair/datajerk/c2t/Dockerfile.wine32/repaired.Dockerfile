# docker build --no-cache -t wine32 -f Dockerfile.wine32 .
FROM ubuntu:19.10

ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -qy --no-install-recommends install wine32 && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
RUN wine foobar || true
