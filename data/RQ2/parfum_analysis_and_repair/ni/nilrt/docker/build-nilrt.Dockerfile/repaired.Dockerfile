ARG PYREX_IMAGE
FROM ${PYREX_IMAGE} as build-nilrt

# ISO and QEMU utilities are needed by the build.vm.sh pipeline scriptlet.
RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes \
	genisoimage \
	qemu-system-x86 \
	qemu-utils \
"" && rm -rf /var/lib/apt/lists/*;

# this Dockerfile layer contains nothing yet.
