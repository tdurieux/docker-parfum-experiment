FROM ubuntu:18.04

LABEL maintainer="Pawsey Supercomputing Centre"
LABEL version="v0.0.1"

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install fortune cowsay lolcat && rm -rf /var/lib/apt/lists/*;

ENV PATH=/usr/games:$PATH

CMD fortune | cowsay | lolcat
