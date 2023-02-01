# Usage:
#
# This uses a custom installs a kernel module hence the mounts

# docker run --rm -it \
# 	--name wireguard \
# 	-v /lib/modules:/lib/modules \
# 	-v /usr/src:/usr/src:ro \
# 	r.j3ss.co/wireguard:install
#
FROM alpine:latest
LABEL maintainer "Jessie Frazelle <jess@linux.com>"

RUN apk add --no-cache \
	build-base \
	ca-certificates \
	elfutils-libelf \
	libelf-dev \
	libmnl-dev

# https://git.zx2c4.com/WireGuard/refs/