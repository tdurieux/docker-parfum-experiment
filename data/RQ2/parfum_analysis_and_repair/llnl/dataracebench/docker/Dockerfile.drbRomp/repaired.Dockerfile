# pull base image

FROM ubuntu:18.04

# install gcc git fortran package later that only for test
RUN groupadd -g 9999 drb && \
    useradd -r -u 9999 -g drb -m -d /home/drb drb

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        apt-utils \
        dialog \
        software-properties-common \
        wget && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        bc \
        build-essential \
        cmake \
        curl \
        gdb \
        git \
        python3-dev \
        time \
        vim && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/*

USER drb
WORKDIR /home/drb

RUN git clone --branch  romp-build  https://github.com/peihunglin/spack.git

ENV PATH=$PATH:/home/drb/spack/bin
RUN spack install environment-modules 
RUN pathname="$(spack location --install-dir environment-modules)" && cd $pathname && \
     /bin/bash -c ". init/bash"

RUN spack install gcc@10.3.0
RUN gccpath="$(spack location --install-dir gcc@10.3.0)" &&  \
    spack compiler find $gccpath && \
    spack install romp@master %gcc@10.3.0

#RUN   echo "packages:\nall:\ncompiler: [gcc@7.4.0]" >> ~/.spack/packages.yaml

#RUN pathname="$(spack location --install-dir environment-modules)" && cd $pathname && \
#    /bin/bash -c ". init/bash" && \
#    /bin/bash -c "module use spack/share/spack/modules/linux-ubuntu18.04-haswell"
#    module load gcc-7.4.0-gcc-7.5.0-v2m5xyf && \
#    spack install romp@master


#ENV DYNINSTAPI_RT_LIB=`spack location --install-dir dyninst`/lib/libdyninstAPI_RT.so
#ENV ROMP_PATH=`spack location --install-dir romp`/lib/libromp.so
#ENV PATH=$PATH:`spack location --install-dir romp`/bin
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`spack location --install-dir dyninst`/lib:`spack location --install-dir llvm-openmp@romp-mod`/lib
