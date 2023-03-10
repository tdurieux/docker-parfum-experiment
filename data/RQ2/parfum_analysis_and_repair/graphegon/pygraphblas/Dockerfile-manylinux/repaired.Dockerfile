ARG BASE_CONTAINER=quay.io/pypa/manylinux2010_x86_64
FROM ${BASE_CONTAINER}

RUN yum install -y cmake make gcc git openmpi-devel llvm-devel && rm -rf /var/cache/yum

ARG SS_RELEASE=v4.0.3
ARG SS_COMPACT=0

WORKDIR /build
RUN git clone https://github.com/DrTimothyAldenDavis/GraphBLAS.git --depth 1 --branch $SS_RELEASE

WORKDIR /build/GraphBLAS/build
RUN cmake .. -DGBCOMPACT=${SS_COMPACT} && make -j8 && make install
RUN ldconfig
RUN /bin/rm -Rf /build
