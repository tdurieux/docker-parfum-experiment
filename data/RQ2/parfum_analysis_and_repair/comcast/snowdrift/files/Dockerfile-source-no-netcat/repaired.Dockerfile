#
# Built from https://github.com/panubo/docker-sshd
#
FROM docker.io/panubo/sshd:1.0.3

# Add bash and remove Netcat
RUN apk update \
	&& apk add --no-cache bash \
	&& rm -fv /usr/bin/nc

# No need for an ENTRYPOINT, as the source Docker image provides one.

