############################################################
#
# Minor updates.
# - libelf-dev for kernel 4.14
# - cryptsetup-bin
#
############################################################
FROM opennetworklinux/builder8:1.7
MAINTAINER Jeffrey Townsend <jeffrey.townsend@bigswitch.com>

RUN apt-get update && apt-get install -y --no-install-recommends libelf-dev && apt-get install -y --no-install-recommends cryptsetup-bin && rm -rf /var/lib/apt/lists/*;

#
# Docker shell and other container tools.
#
COPY docker_shell /bin/docker_shell
COPY container-id /bin/container-id
