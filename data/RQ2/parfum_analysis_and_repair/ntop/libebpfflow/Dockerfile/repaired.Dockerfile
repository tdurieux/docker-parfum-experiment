FROM ubuntu:18.04

RUN echo "deb [trusted=yes] http://repo.iovisor.org/apt/bionic bionic-nightly main" | \
  tee /etc/apt/sources.list.d/iovisor.list && \
  apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y bcc-tools && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libcurl4-openssl-dev libjson-c-dev libzmq3-dev libbpfcc-dev && rm -rf /var/lib/apt/lists/*;

COPY ebpflowexport /usr/share/

ENTRYPOINT ["/usr/share/ebpflowexport"]

