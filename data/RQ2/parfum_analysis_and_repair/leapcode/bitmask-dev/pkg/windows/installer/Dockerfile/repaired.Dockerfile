FROM debian:jessie
MAINTAINER paixu@0xn0.de
RUN apt-get update && apt-get -y --no-install-recommends install \
    nsis && rm -rf /var/lib/apt/lists/*; ######
# install packages required to build



WORKDIR /var/src/bitmask/pkg/windows

######
# set a specific user
# needs external tuning of the /var/dist rights!
# RUN useradd installer
# USER installer
ENTRYPOINT ["/var/src/bitmask/pkg/windows/installer-build.sh"]