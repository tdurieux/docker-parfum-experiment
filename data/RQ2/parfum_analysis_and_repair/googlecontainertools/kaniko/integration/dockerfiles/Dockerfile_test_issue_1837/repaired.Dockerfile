FROM registry.access.redhat.com/ubi8/ubi:8.2 AS base
# Install ping
RUN yum --disableplugin=subscription-manager install -y iputils && rm -rf /var/cache/yum
RUN setcap cap_net_raw+ep /bin/ping || exit 1

FROM base
RUN [ ! -z "$(getcap /bin/ping)" ] || exit 1