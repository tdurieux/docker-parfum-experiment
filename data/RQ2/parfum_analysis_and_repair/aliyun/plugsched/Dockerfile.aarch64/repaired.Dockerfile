# Copyright 2019-2022 Alibaba Group Holding Limited.
# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
From registry.cn-hangzhou.aliyuncs.com/alinux/alinux3-aa64

RUN yum install python3 python3-devel python3-lxml gcc gcc-c++ wget libyaml-devel -y && \
    yum install python3-pip -y && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir --upgrade setuptools && \
    pip3 install --no-cache-dir pyyaml && \
    pip3 install --no-cache-dir sh coloredlogs fire jinja2 docopt && \
    yum install make bison flex python3-lxml python3-six python3-pygments \
                gcc-plugin-devel \
                systemd git \
                elfutils-libelf-devel openssl openssl-devel \
                elfutils-devel-static \
                glibc-static zlib-static \
                libstdc++-static \
                platform-python-devel \
                rpm-build rsync bc perl -y && \
    yum clean all && rm -rf /var/cache/yum

RUN git clone https://gitee.com/src-anolis-sig/gcc-python-plugin.git && \
    mkdir -p /root/rpmbuild/SOURCES && \
    rsync -av gcc-python-plugin/ /root/rpmbuild/SOURCES/ && \
    rpmbuild -ba /root/rpmbuild/SOURCES/gcc-python-plugin.spec && \
    yum install -y /root/rpmbuild/RPMS/aarch64/gcc-python-plugin-0.17-1.1.al8.aarch64.rpm && rm -rf /var/cache/yum

COPY . /usr/local/lib/plugsched/
RUN ln -s /usr/local/lib/plugsched/cli.py /usr/local/bin/plugsched-cli
