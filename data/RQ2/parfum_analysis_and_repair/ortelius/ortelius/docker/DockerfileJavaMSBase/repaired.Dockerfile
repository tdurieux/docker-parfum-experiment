FROM fedora:34

RUN yum -y update; \
    yum -y install python python-pip git sudo unzip which iputils diffutils openssl openssl-libs openssh-clients libnsl.i686 java-1.8.0-openjdk-devel; \
    yum clean all; \
    rm -rf /var/cache/yum; \
    chmod 4755 /usr/bin/ping

ENTRYPOINT /bin/sh