#######################################################################
##- Copyright (c) Huawei Technologies Co., Ltd. 2022. All rights reserved.
# - lcr licensed under the Mulan PSL v2.
# - You can use this software according to the terms and conditions of the Mulan PSL v2.
# - You may obtain a copy of Mulan PSL v2 at:
# -     http://license.coscl.org.cn/MulanPSL2
# - THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR
# - IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR
# - PURPOSE.
# - See the Mulan PSL v2 for more details.
##- @Description: prepare compile container environment
##- @Author: wujing
##- @Create: 2022-03-25
#######################################################################
# This file describes the isulad compile container image.
#
# Usage:
#
# docker build --build-arg http_proxy=YOUR_HTTP_PROXY_IF_NEEDED \
#		--build-arg https_proxy=YOUR_HTTPS_PROXY_IF_NEEDED \
#		-t YOUR_IMAGE_NAME -f ./Dockerfile .


FROM	ubuntu:20.04
MAINTAINER WuJing <wujing50@huawei.com>

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    echo "nameserver 8.8.4.4" >> /etc/resolv.conf && \
    echo "search localdomain" >> /etc/resolv.conf

# Install dependency package
RUN apt update -y && apt upgrade -y && \
	apt install --no-install-recommends -y automake \
			autoconf \
			libtool \
			make \
			gdb \
			strace \
			libcap-dev \
			libxslt-dev \
			graphviz \
			docbook2x \
			libselinux-dev \
			libseccomp-dev \
			libyajl-dev \
			git \
			dnsmasq \
			libcgroup-dev \
			rsync \
			iptables \
			iproute2 \
			net-tools \
			unzip \
			tar \
			wget \
			cppcheck \
			python3 \
			python3-pip \
			libdevmapper-dev \
			xz-utils \
			libtar-dev \
			libcurl4-openssl-dev \
			zlib1g-dev \
			openssl \
			gcc \
			g++ \
			libsqlite3-dev \
			libgpgme-dev \
			expect \
			libsystemd-dev \
			golang \
			bc \
			valgrind \
			e2fsprogs \
			lcov \
			libasan6 \
			lvm2 \
			locales \
			language-pack-en \
			curl \
			cmake \
			libhttp-parser-dev \
			libprotobuf-dev \
			libgrpc-dev \
			libgrpc++-dev \
			protobuf-compiler-grpc \
			libevent-dev \
			libwebsockets-dev \
			libgmock-dev \
			libgtest-dev \
			libarchive-dev \
			tcpdump && rm -rf /var/lib/apt/lists/*;

RUN apt autoremove -y

RUN echo "export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH" >> /etc/bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH" >> /etc/bashrc && \
    echo "/usr/lib" >> /etc/ld.so.conf && \
    echo "/usr/local/lib" >> /etc/ld.so.conf


# disalbe sslverify
RUN git config --global http.sslverify false

# install rust
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
CMD ["/bin/bash"]
