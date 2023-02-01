FROM dentproject/builder9:1.7
MAINTAINER Steven Noble <snoble@netdef.org>

#
# The purpose of this image is fix issues with a expired ca-certificate used by lets encrypt
#
RUN apt-get update && apt-get -y --no-install-recommends install libmnl-dev libelf-dev libcap-dev libxtables-dev libdb-dev && rm -rf /var/lib/apt/lists/*;
RUN xapt -a arm64 libmnl-dev libelf-dev libcap-dev libxtables-dev libdb-dev

RUN rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/*

COPY docker_shell /bin/docker_shell
COPY container-id /bin/container-id
