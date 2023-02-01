# Docker container for Centos 6.5

FROM centos:7.0.1406
MAINTAINER build-team@couchbase.com

USER root
RUN yum clean all && yum swap -y fakesystemd systemd
RUN yum install --setopt=keepcache=0 -y openssh-server sudo deltarpm && rm -rf /var/cache/yum
RUN yum install -y openssh-server sudo && yum clean packages && rm -rf /var/cache/yum
RUN yum install --setopt=keepcache=0 -y ed \
                glibc.i686 \
                make \
                man \
                ncurses-devel \
                numactl-devel \
                openssh-clients openssl-devel \
                python-devel \
                redhat-lsb-core \
                rpm-build \
                ruby rubygems rubygem-rake \
                tar \
                unzip \
                which \
                wget && rm -rf /var/cache/yum

RUN yum groupinstall -y "Development Tools"
RUN yum install -y libevent-devel openssl-devel && rm -rf /var/cache/yum
RUN yum install -y glibc-devel.i686 glibc-devel libstdc++-devel.i686 && rm -rf /var/cache/yum
RUN yum install -y git && rm -rf /var/cache/yum

# Set up for SSH daemon
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa

# Create couchbase user with password-less sudo privs, and give
# ownership of /opt/couchbase
RUN groupadd -g1000 couchbase && \
    useradd couchbase -g couchbase -u1000 -G wheel -m -s /bin/bash && \
    mkdir /opt/couchbase && chown -R couchbase:couchbase /opt/couchbase && \
    echo 'couchbase:couchbase' | chpasswd && \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/wheel_group && \
    echo 'Defaults:%wheel !requiretty' >> /etc/sudoers.d/wheel_group && \
    chmod 440 /etc/sudoers.d/wheel_group

# JDK for Jenkins.
RUN yum --setopt=keepcache=0 -y install java-1.8.0-openjdk && rm -rf /var/cache/yum

### Install Couchbase build dependencies ######################################
# * Packages from the base CentOS repository
RUN yum install --setopt=keepcache=0 -y \
                ed \
                gcc \
                gcc-c++ \
                git \
                glibc.i686 \
                make \
                man \
                ncurses-devel \
                numactl-devel \
                openssh-clients openssl-devel \
                python-devel \
                redhat-lsb-core \
                rpm-build \
                ruby rubygems rubygem-rake \
                tar \
                unzip \
                which && \
    ln -s /usr/bin/python2.7 /usr/bin/python2.6 && rm -rf /var/cache/yum

# Install third-party build dependencies
RUN yum install -y --setopt=keepcache=0 perl-Data-Dumper && rm -rf /var/cache/yum

# pip
RUN yum install -y --setopt=keepcache=0 https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y --setopt=keepcache=0 python-pip && rm -rf /var/cache/yum

#paramiko
RUN pip install --no-cache-dir paramiko

#boto
RUN pip install --no-cache-dir boto3

# * CMake (from cmake.org)
RUN mkdir /tmp/deploy && \
    curl -f --tlsv1.2 -L https://cmake.org/files/v2.8/cmake-2.8.12.2-Linux-i386.sh -o /tmp/deploy/cmake.sh && \
    (echo y; echo n) | sh /tmp/deploy/cmake.sh --prefix=/usr/local && \
    rm -fr /tmp/deploy

# Expose SSH daemon and run our builder startup script
EXPOSE 22
COPY build/couchbuilder_start.sh /usr/sbin/
ENTRYPOINT [ "/usr/sbin/couchbuilder_start.sh" ]
CMD [ "default" ]

