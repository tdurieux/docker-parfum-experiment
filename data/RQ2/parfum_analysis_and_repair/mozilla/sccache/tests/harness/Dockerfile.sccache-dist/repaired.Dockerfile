FROM ubuntu:18.04 as bwrap-build
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget xz-utils gcc libcap-dev make && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O - https://github.com/projectatomic/bubblewrap/releases/download/v0.3.1/bubblewrap-0.3.1.tar.xz | \
    tar -xJ
RUN cd /bubblewrap-0.3.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-man && \
    make

FROM aidanhs/ubuntu-docker:18.04-17.03.2-ce
RUN apt-get update && \
    apt-get install -y --no-install-recommends libcap2 libssl1.1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY --from=bwrap-build /bubblewrap-0.3.1/bwrap /bwrap
