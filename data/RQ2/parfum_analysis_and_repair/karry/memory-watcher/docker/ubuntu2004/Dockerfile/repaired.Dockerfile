# docker build --tag memory-watcher-ubuntu-2004 docker/ubuntu2004
# docker run --rm=true -it memory-watcher-ubuntu-2004
FROM ubuntu:20.04

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-utils && \
    apt-get install -y --no-install-recommends \
        clang gcc-10 g++-10 libtbb-dev ccache libtool pkg-config cmake ninja-build \
        qt5-default qttools5-dev-tools qttools5-dev libqt5sql5-sqlite libqt5charts5-dev \
        curl git ca-certificates && \
    # upgrade OS
    apt-get -y dist-upgrade && \
    apt-get autoremove -y && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;

ENV CXX g++-10
ENV CC gcc-10

#  Install Catch2
RUN curl -f -o /tmp/catch2_2.13.4-2_amd64.deb https://de.archive.ubuntu.com/ubuntu/pool/universe/c/catch2/catch2_2.13.4-2_amd64.deb && \
    dpkg -i /tmp/catch2_2.13.4-2_amd64.deb && \
    rm /tmp/catch2_2.13.4-2_amd64.deb

COPY build.sh /build.sh
CMD /build.sh
