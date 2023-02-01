############################################################
#
# Update Packages for arm64.
# Additional build dependencies.
#
############################################################
FROM opennetworklinux/builder9:1.1
MAINTAINER Jeffrey Townsend <jeffrey.townsend@bigswitch.com>

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;

# Docker shell and other container tools.
#
COPY docker_shell /bin/docker_shell
COPY container-id /bin/container-id
