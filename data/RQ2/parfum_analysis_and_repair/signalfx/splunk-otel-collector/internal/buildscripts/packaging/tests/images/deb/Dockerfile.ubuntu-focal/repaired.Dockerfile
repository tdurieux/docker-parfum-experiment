# A ubuntu image with systemd enabled.  Must be run with:
# `-d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro` flags
FROM ubuntu:focal

RUN apt-get update && \
    apt-get install --no-install-recommends -yq ca-certificates curl procps systemd wget && rm -rf /var/lib/apt/lists/*;

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i = \
    "systemd-tmpfiles-setup.service" ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/lib/systemd/systemd"]
