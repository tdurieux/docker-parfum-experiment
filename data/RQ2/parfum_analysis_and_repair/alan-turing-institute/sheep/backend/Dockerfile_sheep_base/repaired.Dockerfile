FROM ubuntu:16.04 as sheep_base

### get wget git etc

RUN apt-get update; apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get update; apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

### get gcc-7 (gcc >=6 needed for SEAL).

RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y  ppa:ubuntu-toolchain-r/test
RUN apt-get update; apt-get -y --no-install-recommends install gcc-7 g++-7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update; apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 10
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 10
RUN update-alternatives --set gcc /usr/bin/gcc-7
RUN update-alternatives --set g++ /usr/bin/g++-7

###### get fftw3 (needed for TFHE)
RUN apt-get install --no-install-recommends -y libfftw3-dev && rm -rf /var/lib/apt/lists/*;

###### build cmake from source (to get a new enough version for SEAL)
RUN wget https://cmake.org/files/v3.11/cmake-3.11.4.tar.gz
RUN tar -xvzf cmake-3.11.4.tar.gz && rm cmake-3.11.4.tar.gz
RUN cd cmake-3.11.4; export CC=gcc-7; export CXX=g++-7; ./bootstrap; make -j4; make install

####### install intel-tbb for parallelisation
RUN apt-get -y --no-install-recommends install libtbb-dev && rm -rf /var/lib/apt/lists/*;

###### install PALISADE
RUN apt-get -y --no-install-recommends install lzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install flex && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install bison && rm -rf /var/lib/apt/lists/*;
RUN git clone https://git.njit.edu/palisade/PALISADE.git
RUN cd PALISADE && ./configure.sh
RUN cd PALISADE && echo "@@@@@" && g++ --version && CC=gcc-7 CXX=g++-7 make

# ###### get gmp (needed for HElib)
RUN apt-get -y --no-install-recommends install m4 && rm -rf /var/lib/apt/lists/*;
RUN wget https://gmplib.org/download/gmp/gmp-6.1.0.tar.xz
RUN tar -xvf gmp-6.1.0.tar.xz && rm gmp-6.1.0.tar.xz
RUN cd gmp-6.1.0; export CC=gcc-7; export CXX=g++-7; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; make install

###### get ntl (needed for HElib)
RUN wget https://www.shoup.net/ntl/ntl-11.1.0.tar.gz
RUN tar -xvzf ntl-11.1.0.tar.gz && rm ntl-11.1.0.tar.gz
RUN cd ntl-11.1.0/src; export CC=gcc-7; export CXX=g++-7; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" NTL_GMP_LIP=on NTL_EXCEPTIONS=on; make; make install

###### get cpprestsdk (for the REST API)
RUN apt-get update
RUN apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN git clone --recurse-submodules  https://github.com/Microsoft/cpprestsdk.git casablanca
RUN cd casablanca/Release; mkdir build.debug; cd build.debug; export CC=gcc-7; export CXX=g++-7; cmake .. -DCMAKE_BUILD_TYPE=Debug; make install

###### build SEAL
RUN git clone https://github.com/microsoft/SEAL.git
RUN cd SEAL/native/src; export CC=gcc-7; export CXX=g++-7 ; cmake .; make; make install



###### get and build libpaillier
RUN wget https://hms.isi.jhu.edu/acsc/libpaillier/libpaillier-0.8.tar.gz
RUN tar -xvzf libpaillier-0.8.tar.gz && rm libpaillier-0.8.tar.gz
RUN cd libpaillier-0.8 ; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; make install

RUN mkdir -p SHEEP/backend/lib/

###### build TFHE
RUN cd SHEEP/backend/lib; git clone --recurse-submodules https://github.com/tfhe/tfhe.git
RUN cd SHEEP/backend/lib/tfhe; git reset --hard a65271bc8f5f0015c71351ed8746dd8eec051e29
RUN cd SHEEP/backend/lib/tfhe; git submodule update --init

RUN rm -fr SHEEP/backend/lib/tfhe/build
RUN mkdir -p SHEEP/backend/lib/tfhe/build
RUN cd SHEEP/backend/lib/tfhe/build; export CC=gcc-7; export CXX=g++-7; cmake ../src -DENABLE_TESTS=on -DENABLE_FFTW=on -DCMAKE_BUILD_TYPE=optim -DENABLE_NAYUKI_PORTABLE=off -DENABLE_SPQLIOS_AVX=off -DENABLE_SPQLIOS_FMA=off -DENABLE_NAYUKI_AVX=off
RUN cd SHEEP/backend/lib/tfhe/build; make; make install;

###### build HElib
RUN cd SHEEP/backend/lib; git clone --recurse-submodules https://github.com/shaih/HElib.git
RUN cd SHEEP/backend/lib/HElib; git reset --hard 9c50908a3538f5df77df523e525e1f9841f22eb2
RUN cd SHEEP/backend/lib/HElib; git submodule update --init

RUN cd SHEEP/backend/lib/HElib/src ; export CC=gcc-7; export CXX=g++-7; make clean; make;
