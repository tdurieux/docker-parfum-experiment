FROM ubuntu:14.04

RUN set -o xtrace \
    && sed -i 's,^deb-src,# no src # &,; s,http://archive.ubuntu.com/ubuntu/,mirror://mirrors.ubuntu.com/mirrors.txt,' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;

RUN set -o xtrace \
    && apt-get install --no-install-recommends -y iperf && rm -rf /var/lib/apt/lists/*;

COPY testing /etc/xinetd.d/testing

CMD ["/usr/sbin/xinetd", "-dontfork", "-pidfile", "/run/xinetd.pid", "-inetd_ipv6"]
