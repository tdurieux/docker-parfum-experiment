# Base image 
FROM debian:testing

ARG DLURL

# - Install SimGrid's dependencies
# - Compile and install SimGrid itself
RUN echo "DOWNLOAD_URL: ${DLURL}" && \
    apt update && apt upgrade -y && apt install -y wget && \
    mkdir /source && cd /source && \
    wget https://framagit.org/${DLURL} && \
    tar xf SimGrid-* && rm SimGrid-*tar.gz && \
    cd SimGrid-* && \
    apt install -y g++ gcc git valgrind default-jdk gfortran libboost-dev libboost-all-dev cmake dpkg-dev && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/ -Denable_documentation=OFF -Denable_java=ON -Denable_smpi=ON -Denable_compile_optimizations=ON . && \
    make -j4 && \
    mkdir debian/ && touch debian/control && dpkg-shlibdeps --ignore-missing-info lib/*.so -llib/ -O/tmp/deps && \
    make install && make clean && \
    apt remove -y  g++ gcc git valgrind default-jdk gfortran libboost-dev libboost-all-dev cmake dpkg-dev wget && \
    apt install `sed -e 's/shlibs:Depends=//' -e 's/([^)]*)//g' -e 's/,//g' /tmp/deps` && \
    apt autoremove -y && apt autoclean && apt clean

    