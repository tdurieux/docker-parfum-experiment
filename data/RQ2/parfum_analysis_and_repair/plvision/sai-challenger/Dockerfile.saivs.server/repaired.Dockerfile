FROM debian:buster-slim

MAINTAINER andriy.kokhan@gmail.com

# The sonic-swss-common and sonic-sairedis commits were taken from
# sonic-buildimage master 9c4a7c2 commited on Oct 24, 2021
#
# https://github.com/Azure/sonic-buildimage/tree/9c4a7c2
#
# SAI version:
#   Branch v1.9
#   Tag v1.9.1
#   Commit 740a487
#   Sep 29, 2021

ARG SWSS_COMMON_VER=31f4253
ARG SAIREDIS_VER=433c8df
ARG SAI_VER=740a487

RUN echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian/ buster main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=amd64] http://debian-archive.trafficmanager.net/debian/ buster main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=amd64] http://debian-archive.trafficmanager.net/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian buster-backports main" >> /etc/apt/sources.list

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install generic packages
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install --no-install-recommends -y \
        apt-utils \
        vim \
        curl \
        wget \
        iproute2 \
        unzip \
        git \
        procps \
        build-essential \
        graphviz \
        doxygen \
        aspell \
        python3-pip \
        rsyslog \
        supervisor && rm -rf /var/lib/apt/lists/*;

# Add support for supervisord to handle startup dependencies
RUN pip3 install --no-cache-dir supervisord-dependent-startup==1.4.0

# Install dependencies
RUN apt-get install --no-install-recommends -y redis-server libhiredis0.14 && rm -rf /var/lib/apt/lists/*;

# Install sonic-swss-common & sonic-sairedis building dependencies
RUN apt-get install --no-install-recommends -y \
        make libtool m4 autoconf dh-exec debhelper automake cmake pkg-config \
        libhiredis-dev libnl-3-dev libnl-genl-3-dev libnl-route-3-dev swig3.0 \
        libpython2.7-dev libgtest-dev libboost-dev autoconf-archive && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
        libnl-3-dev libnl-genl-3-dev libnl-route-3-dev libnl-nf-3-dev libzmq3-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone --recursive https://github.com/Azure/sonic-swss-common \
        && cd sonic-swss-common \
        && git checkout ${SWSS_COMMON_VER} \
        && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && dpkg-buildpackage -us -uc -b \
        && cd .. \
        && dpkg -i libswsscommon_1.0.0_amd64.deb \
        && dpkg -i libswsscommon-dev_1.0.0_amd64.deb \
        && rm -rf sonic-swss-common \
        && rm -f *swsscommon*

WORKDIR /sai

RUN git clone https://github.com/Azure/sonic-sairedis.git \
        && cd sonic-sairedis \
        && git checkout ${SAIREDIS_VER} \
        && git submodule update --init --recursive \
        && cd SAI && git fetch origin \
        && git checkout ${SAI_VER} \
        && git submodule update --init --recursive \
        && cd .. \
        && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-sai=vs && make -j4 \
        && make install && ldconfig \
        && mkdir -p /usr/include/sai \
        && mv SAI/experimental  /usr/include/sai/experimental \
        && mv SAI/inc  /usr/include/sai/inc \
        && mkdir -p /usr/include/sai/meta \
        && cp SAI/meta/*.h  /usr/include/sai/meta/ \
        && mv tests .. && rm -rf * && mv ../tests .


# Build attr_list_generator and generate /etc/sai/sai.json
COPY scripts/gen_attr_list /sai/gen_attr_list

RUN cd /sai/gen_attr_list \
        && [ -d json ] && rm -rf json \
        ; git clone https://github.com/nlohmann/json.git \
        && cd json \
        && git checkout 7440786b813534b567f6f6b87afb2aa19f97cc89 \
        && cd .. \
        && [ -d build ] && rm -rf build \
        ; mkdir build \
        && cd build \
        && cmake .. \
        && make -j$(nproc) \
        && mkdir -p /etc/sai \
        && ./attr_list_generator > /etc/sai/sai.json \
        && rm -rf /sai/gen_attr_list

# Install ptf_nn_agent dependencies
RUN apt-get install --no-install-recommends -y libffi-dev \
        && wget https://github.com/nanomsg/nanomsg/archive/1.0.0.tar.gz \
        && tar xvfz 1.0.0.tar.gz \
        && cd nanomsg-1.0.0 \
        && mkdir -p build \
        && cd build \
        && cmake .. \
        && make install \
        && ldconfig \
        && cd ../.. \
        && rm -rf 1.0.0.tar.gz nanomsg-1.0.0 \
        && pip3 install --no-cache-dir nnpy && rm -rf /var/lib/apt/lists/*;

# Update Redis configuration:
# - Enable keyspace notifications as per sonic-swss-common/README.md
# - Do not daemonize redis-server since supervisord will manage it
# - Do not save Redis DB on disk
RUN sed -ri 's/^# unixsocket/unixsocket/' /etc/redis/redis.conf \
        && sed -ri 's/^unixsocketperm .../unixsocketperm 777/' /etc/redis/redis.conf \
        && sed -ri 's/redis-server.sock/redis.sock/' /etc/redis/redis.conf \
        && sed -ri 's/notify-keyspace-events ""/notify-keyspace-events AKE/' /etc/redis/redis.conf \
        && sed -ri 's/^daemonize yes/daemonize no/' /etc/redis/redis.conf \
        && sed -ri 's/^save/# save/' /etc/redis/redis.conf

# Disable kernel logging support
RUN sed -ri '/imklog/s/^/#/' /etc/rsyslog.conf

# Setup supervisord
COPY scripts/sai.profile /etc/sai.d/sai.profile
COPY scripts/lanemap.ini /usr/share/sonic/hwsku/lanemap.ini
COPY scripts/server/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY scripts/veth-create.sh /usr/bin/veth-create.sh

# Install SAI Challenger CLI dependencies
RUN pip3 install --no-cache-dir click==7.0 pytest redis

# Deploy SAI Challenger CLI
COPY setup.py            /sai-challenger/setup.py
COPY cli/__init__.py     /sai-challenger/cli/__init__.py
COPY cli/main.py         /sai-challenger/cli/main.py
COPY common/setup.py     /sai-challenger/common/setup.py
COPY common/__init__.py  /sai-challenger/common/__init__.py
COPY common/sai.py       /sai-challenger/common/sai.py
COPY common/sai_npu.py   /sai-challenger/common/sai_npu.py
COPY common/sai_dataplane.py         /sai-challenger/common/sai_dataplane.py
COPY topologies          /sai-challenger/topologies
COPY scripts/sai-cli-completion.sh   /sai-challenger/scripts/sai-cli-completion.sh
RUN echo ". /sai-challenger/scripts/sai-cli-completion.sh" >> /root/.bashrc

# Deploy a remote commands listener
COPY scripts/redis-cmd-listener.py   /sai-challenger/scripts/redis-cmd-listener.py

# Install ptf_nn_agent and PTF helpers (required by sai_dataplane.py)
COPY ptf/ptf_nn/ptf_nn_agent.py      /sai-challenger/ptf/ptf_nn/ptf_nn_agent.py
COPY ptf/setup.py                    /sai-challenger/ptf/setup.py
COPY ptf/README.md                   /sai-challenger/ptf/README.md
COPY ptf/src/ptf/*.py                /sai-challenger/ptf/src/ptf/
COPY ptf/requirements.txt            /sai-challenger/ptf/requirements.txt

RUN echo "#mock" > /sai-challenger/ptf/ptf \
        && mkdir /sai-challenger/ptf/src/ptf/platforms \
        && touch /sai-challenger/ptf/src/ptf/platforms/__init__.py \
        && pip3 install --no-cache-dir /sai-challenger/ptf

# Install SAI Challenger CLI and the remote commands listener
RUN pip3 install --no-cache-dir --editable /sai-challenger/common \
        && pip3 install --no-cache-dir --editable /sai-challenger

WORKDIR /sai-challenger

CMD ["/usr/bin/supervisord"]

