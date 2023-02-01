ARG kindBase
FROM ${kindBase}
RUN apt-get update && apt-get -y --no-install-recommends install lvm2 && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/udev_sync =.*/udev_sync = 0/' \
           -e 's/udev_rules =.*/udev_rules = 0/'  /etc/lvm/lvm.conf