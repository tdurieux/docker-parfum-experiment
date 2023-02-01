# Run from top of vpp repo with command:
# docker build -f extras/docker/build/Dockerfile.xenial .
FROM ubuntu:xenial
ARG REPO=master
COPY . /vpp
WORKDIR /vpp
RUN apt-get update
RUN apt-get -y --no-install-recommends install make sudo git curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packagecloud.io/install/repositories/fdio/${REPO}/script.deb.sh | bash
RUN apt-get update
RUN apt-get -y --no-install-recommends install vpp-dpdk-dev && rm -rf /var/lib/apt/lists/*;
RUN UNATTENDED=y make install-dep
RUN make pkg-deb
CMD ["/bin/bash"]