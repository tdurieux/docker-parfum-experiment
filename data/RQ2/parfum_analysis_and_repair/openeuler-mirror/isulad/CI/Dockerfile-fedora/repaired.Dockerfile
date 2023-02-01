#######################################################################
##- Copyright (c) Huawei Technologies Co., Ltd. 2019. All rights reserved.
# - lcr licensed under the Mulan PSL v2.
# - You can use this software according to the terms and conditions of the Mulan PSL v2.
# - You may obtain a copy of Mulan PSL v2 at:
# -     http://license.coscl.org.cn/MulanPSL2
# - THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR
# - IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR
# - PURPOSE.
# - See the Mulan PSL v2 for more details.
##- @Description: prepare compile container environment
##- @Author: haozi007
##- @Create: 2021-12-31
#######################################################################
# This file describes the isulad compile container image.
#
# Usage:
#
# docker build --build-arg http_proxy=YOUR_HTTP_PROXY_IF_NEEDED \
#		--build-arg https_proxy=YOUR_HTTPS_PROXY_IF_NEEDED \
#		-t YOUR_IMAGE_NAME -f ./Dockerfile .

FROM fedora:35
MAINTAINER haozi007 <liuhao27@huawei.com>

# if set proxy, need add no_proxy
# ENV no_proxy=127.0.0.1
# if you run CI in intranet, you need set proxy
# ENV http_proxy=http://proxy.com
# ENV https_proxy=http://proxy.com

RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    echo "nameserver 8.8.4.4" >> /etc/resolv.conf && \
    echo "search localdomain" >> /etc/resolv.conf

# Install dependency package
RUN dnf update -y && dnf install -y systemd && dnf clean all

RUN dnf install -y  automake \
			autoconf \
			libtool \
			make \
			cmake \
			grpc-devel \
			grpc-plugins \
			libevent-devel \
			libwebsockets-devel \
			http-parser-devel \
			gtest-devel \
			gmock-devel \
			libarchive-devel \
			which \
			gdb \
			strace \
			rpm-build \
			graphviz \
			libcap \
			libcap-devel \
			libxslt  \
			docbook2X \
			libselinux \
			libselinux-devel \
			container-selinux \
			libseccomp \
			libseccomp-devel \
			yajl-devel \
			git \
			dnsmasq \
			libcgroup \
			rsync \
			iptables \
			iproute \
			net-tools \
			unzip \
			tar \
			wget \
			cppcheck \
			python3 \
			python3-pip \
			device-mapper-devel \
			xz-devel \
			libtar \
			libtar-devel \
			libcurl-devel \
			zlib-devel \
			glibc-headers \
			openssl-devel \
			gcc \
			gcc-c++ \
			hostname \
			sqlite-devel \
			gpgme \
			gpgme-devel \
			expect \
			systemd-devel \
			systemd-libs \
			go \
			bc \
			procps-ng \
			valgrind \
			e2fsprogs \
			lcov \
			libasan \
			langpacks-en \
			containernetworking-plugins \
			runc \
			lvm2 \
			tcpdump \
			systemd-udev \
			iputils

RUN yum clean all && \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; \
    do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# disalbe sslverify
RUN git config --global http.sslverify false

RUN echo "export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH" >> /etc/bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH" >> /etc/bashrc && \
    echo "/usr/lib" >> /etc/ld.so.conf && \
    echo "/usr/local/lib" >> /etc/ld.so.conf


RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# configure rust
RUN echo "[source.crates-io]" >> ${HOME}/.cargo/config && \
    echo "[source.local-registry]" >> ${HOME}/.cargo/config && \
    echo "directory = \"vendor\"" >> ${HOME}/.cargo/config

# install libevhtp
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
        set -x && \
        cd ~ && \
        git clone https://gitee.com/src-openeuler/libevhtp.git && \
        cd libevhtp && \
        git checkout -b openEuler-20.03-LTS-tag openEuler-20.03-LTS-tag && \
        tar -xzvf libevhtp-1.2.16.tar.gz && \
        cd libevhtp-1.2.16 && \
        patch -p1 -F1 -s < ../0001-support-dynamic-threads.patch && \
        patch -p1 -F1 -s < ../0002-close-openssl.patch && \
        rm -rf build && \
        mkdir build && \
        cd build && \
        cmake -D EVHTP_BUILD_SHARED=on -D EVHTP_DISABLE_SSL=on ../ && \
        make -j $(nproc) && \
        make install && \
        ldconfig && rm libevhtp-1.2.16.tar.gz

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
WORKDIR /root
