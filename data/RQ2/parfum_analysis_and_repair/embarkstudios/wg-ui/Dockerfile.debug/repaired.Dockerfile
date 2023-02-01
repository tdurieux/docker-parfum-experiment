FROM embarkstudios/wireguard-ui AS latest

FROM ubuntu:20.04
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y software-properties-common iptables curl iproute2 ifupdown iputils-ping && \
    echo resolvconf resolvconf/linkify-resolvconf boolean false | debconf-set-selections && \
    echo "REPORT_ABSENT_SYMLINK=no" >> /etc/default/resolvconf && \
    apt-get install -y --no-install-recommends resolvconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -qy --no-install-recommends wireguard && rm -rf /var/lib/apt/lists/*;
COPY --from=latest /wireguard-ui /
ENTRYPOINT [ "/wireguard-ui" ]
