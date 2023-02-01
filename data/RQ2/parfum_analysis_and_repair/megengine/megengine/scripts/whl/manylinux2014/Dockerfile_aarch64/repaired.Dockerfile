FROM quay.io/pypa/manylinux2014_aarch64:2020-12-31-56195b3

ENV UID=1024 PATH=${PATH}:/usr/local/cuda/bin

ARG platform
COPY setup_mirror.sh .
RUN ./setup_mirror.sh "$platform"

ADD init_image.sh /tmp
RUN /tmp/init_image.sh aarch64 && rm -f /tmp/init_image.sh