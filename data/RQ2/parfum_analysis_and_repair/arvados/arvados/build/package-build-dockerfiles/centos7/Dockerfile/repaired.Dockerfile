# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: AGPL-3.0

ARG HOSTTYPE
ARG BRANCH
ARG GOVERSION

FROM centos:7 as build_x86_64
# Install go
ONBUILD ARG GOVERSION
ONBUILD ADD generated/go${GOVERSION}.linux-amd64.tar.gz /usr/local/
ONBUILD RUN ln -s /usr/local/go/bin/go /usr/local/bin/
# Install nodejs and npm
ONBUILD ADD generated/node-v10.23.1-linux-x64.tar.xz /usr/local/
ONBUILD RUN ln -s /usr/local/node-v10.23.1-linux-x64/bin/* /usr/local/bin/

FROM centos:7 as build_aarch64
# Install go
ONBUILD ARG GOVERSION
ONBUILD ADD generated/go${GOVERSION}.linux-arm64.tar.gz /usr/local/
ONBUILD RUN ln -s /usr/local/go/bin/go /usr/local/bin/
# Install nodejs and npm
ONBUILD ADD generated/node-v10.23.1-linux-arm64.tar.xz /usr/local/
ONBUILD RUN ln -s /usr/local/node-v10.23.1-linux-arm64/bin/* /usr/local/bin/

FROM build_${HOSTTYPE}

MAINTAINER Arvados Package Maintainers <packaging@arvados.org>

ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-c"]
# Install dependencies.
RUN yum -q -y install make automake gcc gcc-c++ libyaml-devel patch readline-devel zlib-devel libffi-devel openssl-devel bzip2 libtool bison sqlite-devel rpm-build git perl-ExtUtils-MakeMaker libattr-devel nss-devel libcurl-devel which tar unzip scl-utils centos-release-scl postgresql-devel fuse-devel xz-libs git wget pam-devel && rm -rf /var/cache/yum

# Install RVM
ADD generated/mpapis.asc /tmp/
ADD generated/pkuczynski.asc /tmp/
RUN gpg --batch --import --no-tty /tmp/mpapis.asc && \
    gpg --batch --import --no-tty /tmp/pkuczynski.asc && \
    curl -f -L https://get.rvm.io | bash -s stable && \
    /usr/local/rvm/bin/rvm install 2.7 -j $(grep -c processor /proc/cpuinfo) && \
    /usr/local/rvm/bin/rvm alias create default ruby-2.7 && \
    echo "gem: --no-document" >> ~/.gemrc && \
    /usr/local/rvm/bin/rvm-exec default gem install bundler --version 2.2.19 && \
    /usr/local/rvm/bin/rvm-exec default gem install fpm --version 1.10.2

# Install Bash 4.4.12 // see https://dev.arvados.org/issues/15612
RUN cd /usr/local/src \
&& wget https://ftp.gnu.org/gnu/bash/bash-4.4.12.tar.gz \
&& wget https://ftp.gnu.org/gnu/bash/bash-4.4.12.tar.gz.sig \
&& tar xzf bash-4.4.12.tar.gz \
&& cd bash-4.4.12 \
&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/$( basename $( pwd ) ) \
&& make \
&& make install \
&& ln -sf /usr/local/src/bash-4.4.12/bash /bin/bash && rm bash-4.4.12.tar.gz

# Need to "touch" RPM database to workaround bug in interaction between
# overlayfs and yum (https://bugzilla.redhat.com/show_bug.cgi?id=1213602)
RUN touch /var/lib/rpm/* && yum -q -y install python3 python3-pip python3-devel && rm -rf /var/cache/yum

# Install virtualenv
RUN /usr/bin/pip3 install 'virtualenv<20'

RUN /usr/local/rvm/bin/rvm-exec default bundle config --global jobs $(let a=$(grep -c processor /proc/cpuinfo )-1; echo $a)
# Cf. https://build.betterup.com/one-weird-trick-that-will-speed-up-your-bundle-install/
ENV MAKE "make --jobs $(grep -c processor /proc/cpuinfo)"

# Preseed the go module cache and the ruby gems, using the currently checked
# out branch of the source tree. This avoids potential compatibility issues
# between the version of Ruby and certain gems.
RUN git clone --depth 1 git://git.arvados.org/arvados.git /tmp/arvados && \
    cd /tmp/arvados && \
    if [[ -n "${BRANCH}" ]]; then git checkout ${BRANCH}; fi && \
    cd /tmp/arvados/services/api && \
    /usr/local/rvm/bin/rvm-exec default bundle install && \
    cd /tmp/arvados/apps/workbench && \
    /usr/local/rvm/bin/rvm-exec default bundle install && \
    cd /tmp/arvados && \
    go mod download

# The version of setuptools that comes with CentOS is way too old
RUN pip3 install --no-cache-dir 'setuptools<45'

ENV WORKSPACE /arvados
CMD ["/usr/local/rvm/bin/rvm-exec", "default", "bash", "/jenkins/run-build-packages.sh", "--target", "centos7"]
