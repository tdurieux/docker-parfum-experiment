# FROM ubuntu:15.10
FROM ubuntu
MAINTAINER Marco Canini <marco.canini@gmail.com>

RUN apt-get update && apt-get -y --no-install-recommends install \
                        build-essential \
                        fakeroot \
                        debhelper \
                        autoconf \
                        automake \
                        libssl-dev \
                        graphviz \
                        python-all \
                        python-twisted-conch \
                        libtool \
                        git \
                        tmux \
                        vim \
                        python-pip \
                        python-paramiko \
                        python-sphinx \
                        mongodb \
                        dos2unix \
                        ssh \
                        feh \
                        libstring-crc32-perl \
                        python-routes \
                        python-dev \
                        quagga \
                        psmisc \
                        uuid-runtime && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir alabaster
RUN pip install --no-cache-dir pymongo
RUN pip install --no-cache-dir oslo.config
RUN pip install --no-cache-dir msgpack-python
RUN pip install --no-cache-dir eventlet
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir -U exabgp

RUN adduser --home /home/vagrant --disabled-password --gecos '' vagrant
RUN adduser vagrant sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER vagrant
WORKDIR /home/vagrant

RUN echo 'PATH=$PATH:~/iSDX/bin' >> /home/vagrant/.profile
RUN mkdir /home/vagrant/bin && echo "sudo mn -c; sudo mn --topo single,3 --mac --switch ovsk --controller remote" > /home/vagrant/bin/mininet.sh && chmod 755 /home/vagrant/bin/mininet.sh

RUN wget https://openvswitch.org/releases/openvswitch-2.3.2.tar.gz && \
      tar xzf openvswitch-2.3.2.tar.gz && \
      cd openvswitch-2.3.2 && \
      DEB_BUILD_OPTIONS='nocheck' fakeroot debian/rules binary && rm openvswitch-2.3.2.tar.gz

USER root
WORKDIR /home/vagrant
RUN dpkg -i openvswitch-common*.deb python-openvswitch*.deb openvswitch-pki*.deb openvswitch-switch*.deb && \
      rm -rf *openvswitch* && \
      apt-get -y --no-install-recommends install mininet && rm -rf /var/lib/apt/lists/*;

USER vagrant
WORKDIR /home/vagrant
RUN git clone https://github.com/sdn-ixp/iSDX.git
RUN git clone https://github.com/osrg/ryu.git
RUN cp iSDX/setup/ryu-flags.py ryu/ryu/flags.py
RUN cd ryu && \
      sed -i "s/python_version < '2.7'/(python_version != '2.7' and python_version != '3.0')/" tools/pip-requires && \
      sed -i "s/python_version >= '2.7'/(python_version == '2.7' or python_version == '3.0')/" tools/pip-requires

USER root
WORKDIR /home/vagrant/ryu
RUN python ./setup.py install

USER vagrant
WORKDIR /home/vagrant/iSDX
RUN chmod 755 xrs/client.py xrs/route_server.py && \
      mkdir xrs/ribs && \
      dos2unix launch.sh xrs/client.py pctrl/clean.sh

USER root
WORKDIR /home/vagrant
# ENTRYPOINT service openvswitch-switch start && su - vagrant
