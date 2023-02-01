FROM debian:VERSION
MAINTAINER packager@ntop.org

# Debian jessie doesn't support apt install so ne need to install using dpkg -i and then fix missing dependencies with apt-get install -f

RUN apt-get update && \
    apt-get -y --no-install-recommends -q install wget gnupg lsb-release net-tools ethtool apt-utils && \
    wget -q https://aptSTABLE.ntop.org/VERSION/all/apt-ntopSTABLE.deb && \
    dpkg -i apt-ntopSTABLE.deb; rm -rf /var/lib/apt/lists/*; apt-get install -y -f && \
    rm -f apt-ntopSTABLE.deb

BACKPORTS
APT_SOURCES_LIST

RUN apt-get clean all && \
    apt-get update

RUN apt-get -y --no-install-recommends install PACKAGES_LIST && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y remove PACKAGES_LIST

RUN apt-get -y --no-install-recommends install PACKAGES_LIST && rm -rf /var/lib/apt/lists/*;

COPY ENTRYPOINT_PATH /tmp
ENTRYPOINT ["/tmp/ENTRYPOINT_SH"]
