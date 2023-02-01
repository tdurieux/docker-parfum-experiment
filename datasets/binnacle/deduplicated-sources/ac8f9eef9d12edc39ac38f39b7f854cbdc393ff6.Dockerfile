FROM centos:centos6

RUN yum install -y git curl wget zlib-devel xz-devel bzip2-devel openssl-devel libcurl-devel && \
    wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo && \
    yum install -y devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++ && \
    source scl_source enable devtoolset-2 && \
    echo "source scl_source enable devtoolset-2" >> ~/.bashrc && \
    echo "source scl_source enable devtoolset-2" >> ~/.bash_profile && \
    wget --quiet https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz && \
    tar xzf m4-1.4.18.tar.gz && cd m4* && ./configure && make && make install && cd .. && rm -rf m4* && \
    wget --quiet http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz && \
    tar xzf autoconf-2.69.tar.gz && \
    cd autoconf* && ./configure && make && make install && cd .. && rm -rf autoconf* && \
    git clone --depth 1 https://github.com/ebiggers/libdeflate.git && \
    cd libdeflate && make -j 2 CFLAGS='-fPIC -O3' libdeflate.a && \
    cp libdeflate.a /usr/local/lib && cp libdeflate.h /usr/local/include && \
    cd .. && rm -rf libdeflate && \
    git clone https://github.com/samtools/htslib && \
    cd htslib && git checkout 1.9 && autoheader && autoconf && \
    ./configure --enable-libcurl --with-libdeflate && \
    cd .. && make -j4 CFLAGS="-fPIC -O3" -C htslib install && \
    echo "/usr/local/lib" >> etc/ld.so.conf && \
    ldconfig

RUN cd / && \
    git clone -b devel --depth 10 git://github.com/nim-lang/nim nim && \
    cd nim && \
    chmod +x ./build_all.sh && \
    scl enable devtoolset-2 ./build_all.sh && \
    echo 'PATH=/nim/bin:/root/.nimble/bin:$PATH' >> ~/.bashrc && \
    echo 'PATH=/nim/bin:/root/.nimble/bin:$PATH' >> ~/.bash_profile

RUN cd /   \
    && export PATH=/nim/bin:/root/.nimble/bin:$PATH && \
    source scl_source enable devtoolset-2  && \
    nimble install -y nimgen && \
    cd / && git clone -b dev https://github.com/brentp/duktape-nim && \
    cd duktape-nim && \
    nimble install --verbose -y && \
    git clone --depth 1 git://github.com/brentp/slivar.git && \
    cd slivar && \
    nimble install --verbose -y && \
    nim c -d:release -o:/usr/bin/slivar --passC:-flto src/slivar && \
    rm -rf /slivar /duktape-nim && slivar expr -h
