# Base image: use a named release to avoid names clashes when calling apt upgrade on the resulting image
# debian:11 is Bullseye, release 2021-08-14
FROM debian:11

ARG DLURL

# - Install SimGrid's dependencies
# - Compile and install SimGrid itself
RUN echo "DOWNLOAD_URL: ${DLURL}" && \
    apt-get update && apt upgrade -y && apt install --no-install-recommends -y wget && \
    mkdir /source && cd /source && \
    wget https://framagit.org/${DLURL} && \
    tar xf simgrid-* && rm simgrid-*tar.gz && \
    cd simgrid-* && \
    apt install --no-install-recommends -y g++ gcc git valgrind gfortran libboost-dev libboost-all-dev libeigen3-dev cmake dpkg-dev python3-dev pybind11-dev && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/ -Denable_documentation=OFF -Denable_smpi=ON -Denable_compile_optimizations=ON . && \
    make -j4 && \
    mkdir debian/ && touch debian/control && dpkg-shlibdeps --ignore-missing-info lib/*.so -llib/ -O/tmp/deps && \
    make install && make clean && \
    apt remove -y  g++ gcc git valgrind default-jdk gfortran libboost-dev libboost-all-dev libeigen3-dev cmake dpkg-dev wget python3-dev pybind11-dev && \
    apt install -y --no-install-recommends `sed -e 's/shlibs:Depends=//' -e 's/([^)]*)//g' -e 's/,//g' /tmp/deps` && \
    apt autoremove -y && apt autoclean && apt clean && rm -rf /var/lib/apt/lists/*;
