# Dockerfile to build a "fedoradev" image that can be used in
# a multi-stage Dockerfile to produce a Fedora-based docker image
#
# docker build -t fedoradev:latest .
#
FROM fedora:28

RUN \
    dnf install -y cmake gcc-c++ make gdb git \
    && cd /home \
    && git clone https://github.com/nlohmann/json.git \
    && cd /home/json \
    && mkdir build \
    && cd build \
    && cmake -DJSON_BuildTests=OFF .. \
    && make install
