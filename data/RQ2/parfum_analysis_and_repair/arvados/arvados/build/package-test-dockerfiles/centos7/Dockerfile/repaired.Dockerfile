# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: AGPL-3.0

FROM centos:7
MAINTAINER Arvados Package Maintainers <packaging@arvados.org>

# Install dependencies.
RUN yum -q -y install scl-utils centos-release-scl which tar wget && rm -rf /var/cache/yum

# Install RVM
ADD generated/mpapis.asc /tmp/
ADD generated/pkuczynski.asc /tmp/
RUN touch /var/lib/rpm/* && \
    gpg --batch --import --no-tty /tmp/mpapis.asc && \
    gpg --batch --import --no-tty /tmp/pkuczynski.asc && \
    curl -f -L https://get.rvm.io | bash -s stable && \
    /usr/local/rvm/bin/rvm install 2.7 -j $(grep -c processor /proc/cpuinfo) && \
    /usr/local/rvm/bin/rvm alias create default ruby-2.7 && \
    /usr/local/rvm/bin/rvm-exec default gem install bundler --version 2.2.9

# Install Bash 4.4.12  // see https://dev.arvados.org/issues/15612
RUN cd /usr/local/src \
&& wget https://ftp.gnu.org/gnu/bash/bash-4.4.12.tar.gz \
&& wget https://ftp.gnu.org/gnu/bash/bash-4.4.12.tar.gz.sig \
&& tar xzf bash-4.4.12.tar.gz \
&& cd bash-4.4.12 \
&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/$( basename $( pwd ) ) \
&& make \
&& make install \
&& ln -sf /usr/local/src/bash-4.4.12/bash /bin/bash && rm bash-4.4.12.tar.gz

# Add epel, we need it for the python-pam dependency
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -ivh epel-release-latest-7.noarch.rpm

COPY localrepo.repo /etc/yum.repos.d/localrepo.repo
