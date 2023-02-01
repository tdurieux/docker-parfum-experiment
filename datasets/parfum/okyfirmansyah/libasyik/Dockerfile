FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    apt-get install -y build-essential gdb wget git libssl-dev && \
    mkdir ~/temp && cd ~/temp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4.tar.gz && \
    tar -zxvf cmake-3.21.4.tar.gz && \
    cd cmake-3.21.4 && \
    ./bootstrap && make -j4 && make install && \
    rm -rf ~/temp/* && \
    cd ~/temp &&  wget https://sourceforge.net/projects/boost/files/boost/1.73.0/boost_1_73_0.tar.gz && \
    tar -zxvf boost_1_73_0.tar.gz && cd boost_1_73_0 && ./bootstrap.sh && ./b2 cxxflags="-std=c++17" --reconfigure --with-fiber --with-date_time install && \
    cd ~/temp && git clone https://github.com/linux-test-project/lcov.git && cd lcov && make install && cd .. && \
    apt-get install -y libperlio-gzip-perl libjson-perl && \
    rm -rf ~/temp/* && \
    apt-get autoremove -y &&\
    apt-get clean -y &&\
    rm -rf /var/lib/apt/lists/*

RUN apt-get -y update && \
    apt-get install -y libpq-dev libsqlite3-dev unzip && \
    cd ~/temp && \
    git clone https://github.com/jtv/libpqxx.git && cd libpqxx && \
    git checkout 7.1.1 && \
    mkdir build && cd build && \
    cmake .. -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql/libpq && \
    make -j6 && make install && \
    cd ~/temp && \
    wget https://github.com/SOCI/soci/archive/4.0.1.zip && \
    unzip 4.0.1.zip && \
    cd soci-4.0.1 && \
    mkdir build && cd build && \
    cmake .. -DWITH_BOOST=ON -DWITH_POSTGRESQL=ON -DWITH_SQLITE3=ON -DCMAKE_CXX_STANDARD=14 -DSOCI_CXX11=ON && \
    make -j6 && make install && \
    cp /usr/local/cmake/SOCI.cmake /usr/local/cmake/SOCIConfig.cmake && \
    ln -s /usr/local/lib64/libsoci_* /usr/local/lib && ldconfig && \
    rm -rf ~/temp/* && \
    apt-get autoremove -y &&\
    apt-get clean -y &&\
    rm -rf /var/lib/apt/lists/*

ARG DOCKER_TYPE

RUN mkdir /usr/local/libasyik
COPY . /usr/local/libasyik

RUN if [ "$DOCKER_TYPE" = "TEST" ]; then \
    cd /usr/local/libasyik && \
    git submodule update --init --recursive && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && \
    make -j4 && \
    cp tests/libasyik_test  /usr/bin ; \
  fi
  
