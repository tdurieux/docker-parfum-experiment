FROM ubuntu:12.04
MAINTAINER sabalah21@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key update && apt-get update
RUN apt-get install --no-install-recommends -y sudo software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:cartodb/redis && sudo apt-get update
RUN apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]
