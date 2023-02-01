FROM debian:stable

RUN apt-get update; apt-get install --no-install-recommends -y gawk autoconf automake gcc g++ libtool make pkg-config libpcap-dev \
       libxml2-dev libidn11-dev bison flex \
       libssl-dev pkg-config libxslt-dev xsltproc doxygen graphviz \
       bc git \
       python python-dev python-pip python-setuptools python3 python3-dev python3-pip python3-setuptools \
       debmake devscripts debhelper python3-all-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir stdeb; pip3 install --no-cache-dir stdeb

RUN chmod  u+s,o+rx /usr/sbin/useradd /usr/sbin/groupadd; apt-get install --no-install-recommends -y sudo; rm -rf /var/lib/apt/lists/*; sed -i "\$aALL ALL=(ALL) NOPASSWD:ALL" /etc/sudoers

CMD ["/bin/bash"]

