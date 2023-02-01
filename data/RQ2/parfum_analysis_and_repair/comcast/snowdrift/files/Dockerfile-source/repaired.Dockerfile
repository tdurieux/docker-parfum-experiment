#
# Built from https://github.com/panubo/docker-sshd
#
FROM docker.io/panubo/sshd:1.0.3

# Add bash and netcat
RUN apk update \
	&& apk add --no-cache bash

# No need for an ENTRYPOINT, as the source Docker image provides one.

