FROM opennetworklinux/builder7:1.0
MAINTAINER Rob Sherwood <rob.sherwood@bigswitch.com>

RUN apt-get update && apt-get install --no-install-recommends -y \
	libpcap-dev \
        telnet \
        gdb && rm -rf /var/lib/apt/lists/*;
#
# Docker shell and other container tools.
#
COPY docker_shell /bin/docker_shell
COPY container-id /bin/container-id
