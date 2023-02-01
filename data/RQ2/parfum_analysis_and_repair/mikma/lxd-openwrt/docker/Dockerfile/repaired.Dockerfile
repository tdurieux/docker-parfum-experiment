FROM debian:stable-slim as builder

WORKDIR /root/

RUN apt-get update && apt-get -y --no-install-recommends install build-essential subversion fakeroot gawk gpg git wget ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/mikma/lxd-openwrt.git

RUN (cd lxd-openwrt && ./build.sh -v snapshot --type plain)
RUN mkdir rootfs
RUN tar xzf /root/lxd-openwrt/bin/openwrt-snapshot-x86-64-plain.tar.gz -C rootfs && rm /root/lxd-openwrt/bin/openwrt-snapshot-x86-64-plain.tar.gz


FROM scratch

COPY --from=builder /root/rootfs /

COPY init.sh /

RUN mkdir -p /var/lock && opkg update && opkg install luci-ssl

ENTRYPOINT ["/init.sh"]
