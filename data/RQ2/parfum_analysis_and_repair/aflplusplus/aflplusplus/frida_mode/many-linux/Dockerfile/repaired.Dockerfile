FROM fridadotre/manylinux-x86_64

RUN yum -y install xz && rm -rf /var/cache/yum

WORKDIR /AFLplusplus
ENV CFLAGS="\
    -DADDR_NO_RANDOMIZE=0x0040000 \
    -Wno-implicit-function-declaration \
    "
ENV CXX=$CC
