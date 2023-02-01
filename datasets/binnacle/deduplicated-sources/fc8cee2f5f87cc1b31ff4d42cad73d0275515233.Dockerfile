FROM centos:7
MAINTAINER George Bolo <gbolo@linuxctl.com>

# -----------------------------------------------------------------------------
# Import the RPM GPG key for Default Centos 7 Repository
# -----------------------------------------------------------------------------
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7

# -----------------------------------------------------------------------------
# Install sensu repo and packages
# -----------------------------------------------------------------------------
RUN echo $'[sensu] \n\
name=sensu \n\
baseurl=https://sensu.global.ssl.fastly.net/yum/$releasever/$basearch/ \n\
gpgcheck=0 \n\
enabled=1' > /etc/yum.repos.d/sensu.repo && \
    yum update -y && \
    yum install -y sensu && \
    yum clean all && \
    rm -rf /etc/sensu/config.json.example

# -----------------------------------------------------------------------------
# Update PATH for embedded sensu binaries
# -----------------------------------------------------------------------------
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/sensu/embedded/bin

