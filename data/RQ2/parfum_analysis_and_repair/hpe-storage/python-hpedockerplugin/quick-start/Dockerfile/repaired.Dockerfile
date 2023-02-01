FROM ubuntu:14.04.4

ARG http_proxy
ARG https_proxy
ARG no_proxy

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONPATH=${HOME}/python-hpedockerplugin:/root/python-hpedockerplugin

ADD id_rsa /root/.ssh/id_rsa
ADD apt.conf /etc/apt/apt.conf

RUN apt-get update && apt-get upgrade -y
#ADD pre-requisites
RUN apt-get install --no-install-recommends -y python-dev python-setuptools libffi-dev libssl-dev apt multipath-tools open-iscsi sysfsutils git && rm -rf /var/lib/apt/lists/*;
RUN easy_install pip
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -U setuptools
RUN pip install --no-cache-dir pycrypto

#TODO: Enable git clone instead of manual copy of hpedockerplugin repo
#RUN git clone git@github.com:hpe-storage/python-hpedockerplugin.git
COPY python-hpedockerplugin /python-hpedockerplugin

WORKDIR /python-hpedockerplugin
RUN pip install --no-cache-dir --upgrade .

RUN apt-get --yes --no-install-recommends install linux-image-extra-$(uname -r) && rm -rf /var/lib/apt/lists/*;
WORKDIR /python-hpedockerplugin
CMD ["/usr/local/bin/twistd", "--nodaemon", "hpe_plugin_service"]
