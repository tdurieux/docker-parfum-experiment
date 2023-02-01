FROM quay.io/centos/centos:stream8

RUN yum --enablerepo='powertools' install -y make automake autoconf gettext \
    criu-devel libtool gcc libcap-devel systemd-devel yajl-devel \
    libseccomp-devel python36 libtool git && rm -rf /var/cache/yum

COPY run-tests.sh /usr/local/bin

ENTRYPOINT /usr/local/bin/run-tests.sh
