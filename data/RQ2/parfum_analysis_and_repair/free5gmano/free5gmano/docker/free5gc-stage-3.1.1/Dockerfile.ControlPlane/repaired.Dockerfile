FROM golang:1.14.4

WORKDIR /root/

RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt --no-install-recommends -y install wget git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /
RUN git clone --recursive -b v3.1.1 -j `nproc` https://github.com/free5gc/free5gc.git

WORKDIR /free5gc
RUN make amf
RUN make ausf
RUN make nrf
RUN make nssf
RUN make pcf
RUN make smf
RUN make udm
RUN make udr

FROM ubuntu:20.04
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt --no-install-recommends -y install wget curl git iputils-ping tcpdump net-tools nano libmnl-dev libyaml-dev iproute2 iptables dnsutils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /free5gc
COPY --from=0 /free5gc /free5gc

# ENV GIN_MODE=release
