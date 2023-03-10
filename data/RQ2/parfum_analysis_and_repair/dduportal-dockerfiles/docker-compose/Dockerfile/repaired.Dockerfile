FROM debian:8.4

MAINTAINER Damien DUPORTAL <damien.duportal@gmail.com>
MAINTAINER Christophe FURMANIAK <christophe.furmaniak@gmail.com>
MAINTAINER Joseph PAGE <https://github.com/josephpage>
MAINTAINER Ed Morley <https://github.com/edmorley>

ENV DEBIAN_FRONTEND noninteractive
ENV COMPOSE_VERSION 1.12.0

RUN apt-get update -q \
	&& apt-get install -y -q --no-install-recommends curl ca-certificates \
	&& curl -f -o /usr/local/bin/docker-compose -L \
		"https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64" \
	&& chmod +x /usr/local/bin/docker-compose && rm -rf /var/lib/apt/lists/*;

# This container is a chrooted docker-compose
WORKDIR /app
ENTRYPOINT ["/usr/local/bin/docker-compose"]
CMD ["--version"]
