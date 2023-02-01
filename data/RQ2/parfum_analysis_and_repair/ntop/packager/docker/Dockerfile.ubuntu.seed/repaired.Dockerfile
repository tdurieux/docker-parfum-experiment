FROM ubuntu:VERSION
MAINTAINER packager@ntop.org

REPOSITORIES

RUN apt-get update && \
    apt-get -y --no-install-recommends -q install wget lsb-release && \
    wget -q https://aptSTABLE.ntop.org/VERSION/all/apt-ntopSTABLE.deb && \
    apt install --no-install-recommends -y ./apt-ntopSTABLE.deb && \
    rm -f apt-ntopSTABLE.deb && \
    apt-get clean all && \
    apt-get update && rm -rf /var/lib/apt/lists/*;

BACKPORTS

RUN apt-get -y --no-install-recommends install PACKAGES_LIST && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y remove PACKAGES_LIST

RUN apt-get -y --no-install-recommends install PACKAGES_LIST && rm -rf /var/lib/apt/lists/*;

COPY ENTRYPOINT_PATH /tmp
ENTRYPOINT ["/tmp/ENTRYPOINT_SH"]


