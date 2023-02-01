FROM nvidia/cuda:10.2-devel-ubuntu18.04
MAINTAINER Sneha D. Goenka, gsneha@stanford.edu

USER root
WORKDIR /home

RUN apt-get update && \
    apt-get -y --no-install-recommends install git cmake build-essential libboost-all-dev parallel zlib1g-dev wget && \
    apt-get clean && \
    apt-get purge && rm -rf /var/lib/apt/lists/*;

RUN git clone --recursive https://github.com/gsneha26/SegAlign.git
WORKDIR SegAlign
ENV PROJECT_DIR=/home/SegAlign

RUN wget https://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v385/twoBitToFa && \
    chmod +x twoBitToFa && \
    mv twoBitToFa /usr/local/bin/ && \
    wget https://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v385/faToTwoBit && \
    chmod +x faToTwoBit && \
    mv faToTwoBit /usr/local/bin/ && \
    cd ${PROJECT_DIR}/submodules/lastz/src && \
    make -j $(nproc) && \
    cp ${PROJECT_DIR}/submodules/lastz/src/lastz /usr/local/bin/ && \
    mkdir -p ${PROJECT_DIR}/build && \
    cd ${PROJECT_DIR}/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DTBB_ROOT=${PROJECT_DIR}/submodules/TBB -DCMAKE_PREFIX_PATH=${PROJECT_DIR}/submodules/TBB/cmake .. && \
    make -j $(nproc) && \
    cp ${PROJECT_DIR}/build/segalign* /usr/local/bin && \
    cp ${PROJECT_DIR}/scripts/run_segalign* /usr/local/bin && \
    rm -rf ${PROJECT_DIR}/bin
