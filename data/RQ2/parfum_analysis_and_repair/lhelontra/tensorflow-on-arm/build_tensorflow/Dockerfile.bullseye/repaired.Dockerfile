FROM debian:bullseye

RUN dpkg --add-architecture armhf && dpkg --add-architecture arm64 \
    && apt-get update && apt-get install --no-install-recommends -y \
        openjdk-11-jdk automake autoconf libpng-dev \
        curl zip unzip libtool swig zlib1g-dev pkg-config git wget xz-utils \
        python3-pip python3-mock \
        libpython3-dev libpython3-all-dev \
        libpython3-dev:armhf libpython3-all-dev:armhf \
        libpython3-dev:arm64 libpython3-all-dev:arm64 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir "numpy<1.19.0"

# NOTE: forcing gcc 8.3 as default (prevents internal compiler error: in emit_move_insn, at expr.c bug in gcc-6 of stretch)
RUN echo "deb http://ftp.us.debian.org/debian/ buster main contrib non-free" > /etc/apt/sources.list.d/buster.list \
    && apt-get update && apt-get install --no-install-recommends -y --allow-downgrades gcc-8 g++-8 gcc=4:8.3.0-1 g++=4:8.3.0-1 cpp=4:8.3.0-1 \
    && rm -f /etc/apt/sources.list.d/buster.list \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir -U --user keras_applications==1.0.8 --no-deps \
    && pip3 install --no-cache-dir -U --user keras_preprocessing==1.1.0 --no-deps \
    && ldconfig

RUN /bin/bash -c "update-alternatives --install /usr/bin/python python /usr/bin/python3 150"

WORKDIR /root
RUN git clone https://github.com/lhelontra/tensorflow-on-arm/

WORKDIR /root/tensorflow-on-arm/build_tensorflow/
RUN git checkout v2.3.0
CMD ["/bin/bash"]
