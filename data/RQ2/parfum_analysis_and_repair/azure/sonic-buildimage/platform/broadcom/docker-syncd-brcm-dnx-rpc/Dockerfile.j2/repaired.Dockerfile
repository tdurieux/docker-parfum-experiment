FROM docker-syncd-brcm-dnx-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

COPY \
{% for deb in docker_syncd_brcm_dnx_rpc_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN apt-get purge -y syncd

## Pre-install the fundamental packages
RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    net-tools \
    python3-pip \
    python-setuptools \
    build-essential \
    libssl-dev \
    libffi-dev \
    python-dev \
    wget \
    cmake \
    libqt5core5a \
    libqt5network5 \
    libboost-atomic1.74.0 && rm -rf /var/lib/apt/lists/*;

RUN dpkg_apt() { [ -f $1 ] && { dpkg -i $1 || apt-get -y install -f; } || return 1; } ; \
{% for deb in docker_syncd_brcm_dnx_rpc_debs.split(' ') -%}
dpkg_apt debs/{{ deb }}{{'; '}}
{%- endfor %}

RUN wget https://github.com/nanomsg/nanomsg/archive/1.0.0.tar.gz \
 && tar xvfz 1.0.0.tar.gz \
 && cd nanomsg-1.0.0    \
 && mkdir -p build      \
 && cmake .             \
 && make install        \
 && ldconfig            \
 && cd ..               \
 && rm -fr nanomsg-1.0.0 \
 && rm -f 1.0.0.tar.gz \
 && pip2 install --no-cache-dir cffi==1.7.0 \
 && pip2 install --no-cache-dir --upgrade cffi==1.7.0 \
 && pip2 install --no-cache-dir wheel \
 && pip2 install --no-cache-dir nnpy \
 && mkdir -p /opt \
 && cd /opt \
 && wget https://raw.githubusercontent.com/p4lang/ptf/master/ptf_nn/ptf_nn_agent.py \
 && apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y \
 && rm -rf /root/deps

COPY ["ptf_nn_agent.conf", "/etc/supervisor/conf.d/"]

ENTRYPOINT ["/usr/local/bin/supervisord"]
