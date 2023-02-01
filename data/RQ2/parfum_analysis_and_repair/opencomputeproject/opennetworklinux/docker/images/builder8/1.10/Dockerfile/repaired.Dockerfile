FROM opennetworklinux/builder8:1.9
MAINTAINER Jeffrey Townsend <jeffrey.townsend@bigswitch.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get install --no-install-recommends linux-perf-4.9 linux-tools-3.16 linux-tools -y && rm -rf /var/lib/apt/lists/*;

#
# Docker shell and other container tools.
#
COPY docker_shell /bin/docker_shell
COPY container-id /bin/container-id
