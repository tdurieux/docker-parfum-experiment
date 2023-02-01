FROM calico/bpftool:v5.3-s390x as bpftool

FROM s390x/debian:10-slim

# Install remaining runtime deps required for felix from the global repository
RUN apt-get update && apt-get install --no-install-recommends -y \
    ipset \
    iptables \
    iproute2 \
    iputils-arping \
    iputils-ping \
    iputils-tracepath \

    net-tools \
    conntrack \
    runit \

    kmod \


    netbase \

    procps \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

# Default to the xtables backend of iptables.
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy
RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# Install tini, the init daemon we use.
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-s390x /sbin/tini

ADD felix.cfg /etc/calico/felix.cfg
ADD calico-felix-wrapper /usr/bin

# Put our binary in /code rather than directly in /usr/bin.  This allows the downstream builds
# to more easily extract the Felix build artefacts from the container.
ADD bin/calico-felix-s390x /code/calico-felix
ADD bin/calico-bpf /usr/bin/calico-bpf

ADD bpf/bin/* /usr/lib/calico/bpf/

RUN ln -s /code/calico-felix /usr/bin
COPY --from=bpftool /bpftool /usr/bin
WORKDIR /code

# Since our binary isn't designed to run as PID 1, run it via the tini init daemon.
RUN chmod +x /sbin/tini
ENTRYPOINT ["/sbin/tini", "--"]

# Run felix (via the wrapper script) by default
CMD ["/usr/bin/calico-felix-wrapper"]
