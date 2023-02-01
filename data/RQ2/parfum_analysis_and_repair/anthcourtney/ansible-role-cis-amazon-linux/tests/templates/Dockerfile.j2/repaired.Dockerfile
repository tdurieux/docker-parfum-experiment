FROM lambdalinux/baseimage-amzn:2016.09-000

RUN \

  yum -y install \
    gcc \
    libffi-devel \
    openssl-devel \
    python27-devel \
    python27-pip && \
  pip-2.7 install ansible=={{ test_ansible_version }} && rm -rf /var/cache/yum

ADD . /tmp

WORKDIR /tmp
