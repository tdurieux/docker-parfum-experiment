FROM debian:wheezy

MAINTAINER HU zhenlei

RUN apt-get update \
&& apt-get install --no-install-recommends -y scala && rm -rf /var/lib/apt/lists/*;

COPY src /home/.
COPY docker/docker_start.sh /home

RUN chmod 744 /home/docker_start.sh
ENTRYPOINT /home/docker_start.sh
WORKDIR /home
