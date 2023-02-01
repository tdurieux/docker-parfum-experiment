FROM ubuntu:18.04

ARG vpp_version=master

# Layer0: Prepare sweetcomb environement by installing sysrepo, netopeer2 & vpp
# Layer1: Install vpp
# Layer2: Install sweetcomb

#Layer 0
RUN mkdir -p /opt/dev && apt-get update && \
    apt-get install --no-install-recommends -y build-essential sudo && rm -rf /var/lib/apt/lists/*;
COPY . /opt/dev
WORKDIR /opt/dev
RUN make install-dep && make install-dep-extra
RUN rm -rf /opt/dev/*

#Layer1
RUN apt-get install --no-install-recommends -y curl inetutils-ping \
    && curl -f -s https://packagecloud.io/install/repositories/fdio/$vpp_version/script.deb.sh | bash \
    && apt-get -y --no-install-recommends --force-yes install vpp libvppinfra* vpp-plugin-* vpp-dev vom && rm -rf /var/lib/apt/lists/*;

#Layer2
COPY . /root/src/sweetcomb
WORKDIR /root/src/sweetcomb

RUN make install-dep && make build-plugins
