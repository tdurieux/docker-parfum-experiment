# Docker container for Centos 6.5

FROM centos:6.9
MAINTAINER build-team@couchbase.com

USER root
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

# * CMake (from cmake.org)
RUN mkdir /tmp/deploy && \
    curl -f https://cmake.org/files/v2.8/cmake-2.8.12.2-Linux-i386.sh -o /tmp/deploy/cmake.sh && \
    (echo y; echo n) | sh /tmp/deploy/cmake.sh --prefix=/usr/local && \
    rm -fr /tmp/deploy


# Set up for SSH daemon
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    /etc/init.d/sshd start

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
RUN yum -y install java-1.8.0-openjdk && yum clean packages && rm -rf /var/cache/yum

# pip/paramiko/boto3
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    yum install -y python-pip libffi-devel && \
    pip install --no-cache-dir -U setuptools==33.1.1 && \
    pip install --no-cache-dir PyNaCl==1.1.2 && \
    pip install --no-cache-dir paramiko && \
    pip install --no-cache-dir boto3 && rm -rf /var/cache/yum

# Expose SSH daemon and run our builder startup script
EXPOSE 22
ADD .wgetrc /home/couchbase/.wgetrc
COPY build/couchbuilder_start.sh /usr/sbin/
ENTRYPOINT [ "/usr/sbin/couchbuilder_start.sh" ]
CMD [ "default" ]
