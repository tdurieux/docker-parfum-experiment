FROM ubuntu:bionic

LABEL "localhost" "Pavel Kraynyukhov" version 1.0  maintainer "pavel.kraynyukhov@gmail.com" description "LAppS build environment"

RUN apt-get update \
	&& apt-get dist-upgrade -y

RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y g++-multilib && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y g++-8 --fix-missing && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y autotools-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libpam0g-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libbz2-dev && rm -rf /var/lib/apt/lists/*;


RUN apt-get install --no-install-recommends -y autoconf && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libtool && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

ENV WORKSPACE /root/workspace

RUN mkdir ${WORKSPACE}

WORKDIR ${WORKSPACE}

RUN git clone https://github.com/microsoft/mimalloc.git

WORKDIR ${WORKSPACE}/mimalloc

RUN env CXXFLAGS="-pipe -O2 -march=skylake -mtune=generic -fPIC -fomit-frame-pointer -fstack-check -fstack-protector-strong -mfpmath=sse -msse2avx -mavx2 -ftree-vectorize -funroll-loops" CFLAGS="-pipe -O2 -march=skylake -mtune=generic -fPIC -fomit-frame-pointer -fstack-check -fstack-protector-strong -mfpmath=sse -msse2avx -mavx2 -ftree-vectorize -funroll-loops" CXX="g++ -pipe -O2 -march=skylake -mtune=generic -fPIC -fomit-frame-pointer -fstack-check -fstack-protector-strong -mfpmath=sse -msse2avx -mavx2 -ftree-vectorize -funroll-loops" cmake .

RUN make -j4 all install

WORKDIR ${WORKSPACE}

ADD http://luajit.org/download/LuaJIT-2.0.5.tar.gz ${WORKSPACE}

WORKDIR ${WORKSPACE}

RUN tar xzvf LuaJIT-2.0.5.tar.gz && rm LuaJIT-2.0.5.tar.gz

WORKDIR ${WORKSPACE}/LuaJIT-2.0.5

RUN env LD_LIBRARY_PATH=/usr/local/lib/mimalloc-1.6/ CFLAGS="-pipe -Wall -pthread -O2 -fPIC -march=skylake -mtune=generic -mfpmath=sse -msse2avx -mavx2 -ftree-vectorize -funroll-loops -fstack-check -fstack-protector-strong -fno-omit-frame-pointer" LDFLAGS="-L/usr/local/lib/mimalloc-1.6/ -lmimalloc" make all install

WORKDIR ${WORKSPACE}

ADD https://github.com/wolfSSL/wolfssl/archive/v4.6.0-stable.tar.gz ${WORKSPACE}

RUN ls -la

RUN tar xzvf v4.6.0-stable.tar.gz && rm v4.6.0-stable.tar.gz

WORKDIR ${WORKSPACE}/wolfssl-4.6.0-stable

RUN ./autogen.sh

RUN env LD_LIBRARY_PATH=/usr/local/lib/mimalloc-1.6/ ./configure CFLAGS="-pipe -O2 -march=skylake -mtune=generic -fomit-frame-pointer -fstack-check -fstack-protector-strong -mfpmath=sse -msse2avx -mavx2 -ftree-vectorize -funroll-loops -DWOLFSSL_PUBLIC_MP -DTFM_TIMING_RESISTANT -DECC_TIMING_RESISTANT -DWC_RSA_BLINDING" LDFLAGS="-L/usr/local/lib/mimalloc-1.6/ -lmimalloc" --prefix=/usr/local --enable-tls13 --enable-openssh --enable-aesni --enable-intelasm --enable-keygen --enable-certgen --enable-certreq --enable-curve25519 --enable-ed25519 --enable-intelasm --enable-harden --enable-ecc=nonblock --enable-sp=yes,nonblock

RUN env LD_LIBRARY_PATH=/usr/local/lib/mimalloc-1.6/ make all install

WORKDIR ${WORKSPACE}

ADD https://github.com/fmtlib/fmt/archive/7.1.3.tar.gz ${WORKSPACE}

RUN tar xzvf 7.1.3.tar.gz && rm 7.1.3.tar.gz

WORKDIR ${WORKSPACE}/fmt-7.1.3

RUN cmake . && make && make install

WORKDIR ${WORKSPACE}

RUN rm -rf ITCLib lar utils LAppS

RUN git clone https://github.com/ITpC/ITCLib.git

RUN git clone https://github.com/ITpC/utils.git

RUN git clone https://github.com/ITpC/LAppS.git

RUN git clone https://github.com/ITpC/lar.git

WORKDIR ${WORKSPACE}/LAppS

RUN make clean

