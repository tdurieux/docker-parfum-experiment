# Docker build usage:
# 	docker build . -t sodafoundation/dock:latest
# Docker run usage:
# 	docker run -d --privileged=true --net=host -v /etc/opensds:/etc/opensds sodafoundation/dock:latest

FROM ubuntu:16.04

COPY osdsdock /usr/bin

# Install some packages before running command.
RUN apt-get update && apt-get install --no-install-recommends -y \
 librados-dev librbd-dev ceph-common lvm2 udev tgt \
 && rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/udev_sync = 1/udev_sync = 0/g' /etc/lvm/lvm.conf \
 && sed -i -e 's/udev_rules = 1/udev_rules = 0/g' /etc/lvm/lvm.conf \
 && sed -i -e 's/use_lvmetad = 0/use_lvmetad =1/g' /etc/lvm/lvm.conf

# Define default command.
CMD ["/usr/bin/osdsdock"]
