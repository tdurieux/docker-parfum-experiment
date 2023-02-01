# This will generate an image with the easyOVS installed.
# see: https://github.com/yeasy/easyOVS

FROM yeasy/devbase:python
MAINTAINER Baohua Yang

# install needed software
RUN apt-get install --no-install-recommends openvswitch-switch iptables -y && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/yeasy/easyOVS.git -b dev  && \
bash easyOVS/util/install.sh

WORKDIR /code/easyOVS/

VOLUME ["/var/run/openvswitch/", "/var/run/netns/", "/etc/neutron/",
"/var/lib/neutron"]

ENTRYPOINT [ "/usr/local/bin/easyovs" ]
