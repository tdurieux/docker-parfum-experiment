# Copyright (C) 2016-2020 Intel Corporation
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted for any purpose (including commercial purposes)
# provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions, and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions, and the following disclaimer in the
#    documentation and/or materials provided with the distribution.
#
# 3. In addition, redistributions of modified forms of the source or binary
#    code must carry prominent notices stating that the original code was
#    changed and the date of the change.
#
#  4. All publications or advertising materials mentioning features or use of
#     this software are asked, but not required, to acknowledge that it was
#     developed by Intel Corporation and credit the contributors.
#
# 5. Neither the name of Intel Corporation, nor the name of any Contributor
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# 'recipe' for Docker to build an image of centOS-based
# environment for building the DAOS project.
#

# Pull base image
FROM centos:7
MAINTAINER daos-stack <daos@daos.groups.io>

# Build arguments can be set via --build-arg
# use same UID as host and default value of 1000 if not specified
ARG UID=1000

# for good measure, clean the metadata
RUN yum clean metadata

# Install basic tools
RUN yum -y install epel-release; rm -rf /var/cache/yum \
    yum -y install                                                        \
           boost-devel clang-analyzer cmake CUnit-devel doxygen file flex \
           gcc gcc-c++ git golang graphviz lcov                           \
           libaio-devel libcmocka-devel libevent-devel libiscsi-devel     \
           libtool libtool-ltdl-devel libuuid-devel libyaml-devel         \
           make meson nasm ninja-build numactl-devel openssl-devel        \
           pandoc patch python-requests python2-pygithub                  \
           python36-pylint python36-pep8 python36-requests                \
           python36-pygithub readline-devel sg3_utils ShellCheck yasm     \
           python36-scons openmpi3-devel hwloc-devel

# CaRT specific
RUN yum -y install python36-paramiko python36-PyYAML rsync valgrind && rm -rf /var/cache/yum

# Add CaRT user
ENV USER cart
ENV PASSWD cart
RUN useradd -u $UID -ms /bin/bash $USER
RUN echo "$USER:$PASSWD" | chpasswd

# Set environment variables
ENV PATH=/home/cart/cart/install/bin:$PATH
ENV LD_LIBRARY_PATH=/home/cart/cart/install/Linux/lib:$LD_LIBRARY_PATH
ENV CPATH=/home/cart/cart/install/Linux/include:$CPATH
ENV CRT_PHY_ADDR_STR="ofi+sockets"
ENV OFI_INTERFACE=eth0

ARG JENKINS_URL=""
ARG QUICKBUILD=1
ARG REPOS=""
RUN if [ $QUICKBUILD -eq 0 ]; then \
        echo -e "[repo.dc.hpdd.intel.com_repository_daos-stack-el-7-x86_64-stable-local]\n\
name=created by dnf config-manager from https://repo.dc.hpdd.intel.com/repository/daos-stack-el-7-x86_64-stable-local\n\
baseurl=https://repo.dc.hpdd.intel.com/repository/daos-stack-el-7-x86_64-stable-local\n\
enabled=1\n\
gpgcheck=False\n" >> /etc/yum.repos.d/$repo:$branch:$build_number.repo; \
        for repo in $REPOS; do                                                   \
            branch="master";                                                     \
            build_number="lastSuccessfulBuild";                                  \
            if [[ $repo = *@* ]]; then                                           \
                branch="${repo#*@}";                                             \
                repo="${repo%@*}";                                               \
                if [[ $branch = *:* ]]; then                                     \
                    build_number="${branch#*:}";                                 \
                    branch="${branch%:*}";                                       \
                fi;                                                              \
            fi;                                                                  \
            echo -e "[$repo:$branch:$build_number]\n\
name=$repo:$branch:$build_number\n\
baseurl=${JENKINS_URL}job/daos-stack/job/$repo/job/$branch/$build_number/artifact/artifacts/centos7/\n\
enabled=1\n\
gpgcheck=False\n" >> /etc/yum.repos.d/$repo:$branch:$build_number.repo;          \
        done; \
        pkgs="mercury-devel openpa-devel libfabric-devel"; \
        echo "Installing: $pkgs"; \
        yum -y install $pkgs; rm -rf /var/cache/yum \
    fi

# force an upgrade to get any newly built RPMs
ARG CACHEBUST=1
RUN yum -y upgrade --exclude=mercury-devel,mercury
# Switch to new user
USER $USER
WORKDIR /home/$USER

# set NOBUILD to disable git clone & build
ARG NOBUILD

# Fetch CaRT code
RUN if [ "x$NOBUILD" = "x" ] ; then git clone https://github.com/daos-stack/cart.git; fi
WORKDIR /home/$USER/cart

# Build CaRT & dependencies
RUN if [ "x$NOBUILD" = "x" ] ; then git submodule init && git submodule update; fi
RUN if [ "x$NOBUILD" = "x" ] ; then scons-3 --build-deps=yes USE_INSTALLED=all install; fi
