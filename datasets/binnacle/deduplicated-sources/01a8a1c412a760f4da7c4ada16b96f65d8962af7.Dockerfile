#
#  Copyright (C) 2019 Intel Corporation.
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  1. Redistributions of source code must retain the above copyright notice(s),
#     this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright notice(s),
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER(S) ``AS IS'' AND ANY EXPRESS
#  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE COPYRIGHT HOLDER(S) BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
#  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Pull base image
FROM fedora:29

LABEL maintainer="katarzyna.wasiuta@intel.com"

# Update the dnf cache and install basic tools
RUN dnf update -y && dnf install -y \
    gcc \
    make \
    numactl-devel \
    && dnf clean all 

# Install memkind and memkind-devel
ENV MEMKIND_URL="http://download.opensuse.org/repositories/home:/mbiesek/Fedora_29/x86_64/memkind-1.9.0-2.1.x86_64.rpm"
ENV MEMKIND_DEVEL_URL="http://download.opensuse.org/repositories/home:/mbiesek/Fedora_29/x86_64/memkind-devel-1.9.0-2.1.x86_64.rpm"
RUN rpm -i $MEMKIND_URL && rpm -i $MEMKIND_DEVEL_URL 

# Install redis from copy-on-write poc branch
# TODO: Change url to 5.0-poc_cow tag
ENV REDIS_URL="https://github.com/pmem/redis/archive/5.0-poc_cow.tar.gz"
ENV REDIS_SRC="/usr/src/redis"
RUN mkdir -p $REDIS_SRC && \
    curl -L $REDIS_URL | tar xz --strip-components=1 -C $REDIS_SRC && \
    make -C $REDIS_SRC MALLOC=memkind && \
    make -C $REDIS_SRC install && \
    rm -r $REDIS_SRC
