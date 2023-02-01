# Base image with packages required for add-on `vnc`
#
#     docker build -t rerobots/hs-generic-vnc:latest -f Dockerfile-vnc .
#
#
# SCL <scott@rerobots.net>
# Copyright (C) 2020 rerobots, Inc.

FROM rerobots/hs-generic:x86_64-latest

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    xfce4 \
    xfce4-goodies \
    firefox \
    tightvncserver && rm -rf /var/lib/apt/lists/*;

CMD ["/sbin/rerobots-hs-init.sh"]
