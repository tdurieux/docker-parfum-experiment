FROM quay.io/pypa/manylinux2014_x86_64
COPY build_arts.sh /build_arts.sh
RUN yum -y install cmake3 zlib-devel atlas-devel
ENTRYPOINT ["/build_arts.sh"]
