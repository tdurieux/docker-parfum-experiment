FROM ubuntu:18.04 AS graphene

RUN env DEBIAN_FRONTEND=noninteractive apt-get update \
    && env DEBIAN_FRONTEND=noninteractive apt-get install -y \
        autoconf \
        bison \
        build-essential \
        coreutils \
        gawk \
        git \
        libcurl4-openssl-dev \
        libprotobuf-c-dev \
        meson \
        protobuf-c-compiler \
        python3 \
        python3-pip \
        python3-protobuf \
        wget \
    && python3 -B -m pip install toml>=0.10

RUN git clone {{Graphene.Repository}} /graphene

RUN cd /graphene \
    && git fetch origin {{Graphene.Branch}} \
    && git checkout {{Graphene.Branch}}

{% if SGXDriver.Repository %}
RUN cd /graphene/Pal/src/host/Linux-SGX \
    && git clone {{SGXDriver.Repository}} linux-sgx-driver \
    && cd linux-sgx-driver \
    && git checkout {{SGXDriver.Branch}}
ENV ISGX_DRIVER_PATH "/graphene/Pal/src/host/Linux-SGX/linux-sgx-driver"
{% else %}
ENV ISGX_DRIVER_PATH ""
{% endif %}

RUN cd /graphene \
    && make -s -j WERROR=1 SGX=1 {% if debug %} DEBUG=1 {% endif %} \
    && make -s -j WERROR=1 {% if debug %} DEBUG=1 {% endif %} \
    && meson build --prefix="/graphene/meson_build_output" \
       --buildtype={% if debug %}debug{% else %}release{% endif %} \
       -Ddirect=enabled -Dsgx=enabled \
    && ninja -C build \
    && ninja -C build install