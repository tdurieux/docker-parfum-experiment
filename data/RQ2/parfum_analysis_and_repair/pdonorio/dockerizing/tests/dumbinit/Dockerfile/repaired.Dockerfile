FROM ubuntu:15.10
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@gmail.com>"

RUN apt-get update && apt-get install --no-install-recommends -y wget git && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64.deb
RUN dpkg -i dumb-init_*.deb
