# Base image with packages required for add-on `cam`
#
#     docker build -t rerobots/hs-generic-addon-cam:latest -f Dockerfile-addon-cam .
#
#
# SCL <scott@rerobots.net>
# Copyright (C) 2020 rerobots, Inc.

FROM rerobots/hs-generic:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    python-pip \
    python-opencv \
    python-pillow && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir websocket-client

CMD ["/sbin/rerobots-hs-init.sh"]
