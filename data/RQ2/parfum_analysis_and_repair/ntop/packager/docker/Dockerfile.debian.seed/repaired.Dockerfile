FROM debian:VERSION
MAINTAINER packager@ntop.org

RUN apt-get update && \
    apt-get -y --no-install-recommends -q install wget gnupg lsb-release net-tools ethtool apt-utils && \
    wget -q https://aptSTABLE.ntop.org/VERSION/all/apt-ntopSTABLE.deb && \
    apt install --no-install-recommends -y ./apt-ntopSTABLE.deb && \
    rm -f apt-ntopSTABLE.deb && rm -rf /var/lib/apt/lists/*;

BACKPORTS
APT_SOURCES_LIST

RUN apt-get clean all && \
    apt-get update

RUN apt-get -y --no-install-recommends install PACKAGES_LIST && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y remove PACKAGES_LIST

RUN apt-get -y --no-install-recommends install PACKAGES_LIST && rm -rf /var/lib/apt/lists/*;

COPY ENTRYPOINT_PATH /tmp
ENTRYPOINT ["/tmp/ENTRYPOINT_SH"]
