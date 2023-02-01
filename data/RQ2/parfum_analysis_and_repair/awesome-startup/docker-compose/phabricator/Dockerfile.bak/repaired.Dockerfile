FROM centos:7

MAINTAINER Paul <paul@wizmacau.com>

# Install EPEL
RUN yum install -y epel-release && rm -rf /var/cache/yum

# Update RPM Packages
RUN yum -y update

# Install Nginx
RUN yum install -y nginx git && rm -rf /var/cache/yum

WORKDIR /phabricator

RUN git clone https://github.com/phacility/libphutil.git && \
    git clone https://github.com/phacility/arcanist.git && \
    git clone https://github.com/phacility/phabricator.git

RUN export PATH="$PATH:/somewhere/arcanist/bin/"

RUN yum install -y pcre-devel && rm -rf /var/cache/yum

RUN yum install -y php-pear && pecl install apc && rm -rf /var/cache/yum

RUN yum clean all