FROM ubuntu:latest

MAINTAINER Marcos Pablo Russo <marcospr1974@gmail.com>

RUN apt-get update -y \
    && apt-get install --no-install-recommends tor -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY config/etc/torrc /etc/tor

EXPOSE 9050

#ENTRYPOINT ["./osinted.py"]
