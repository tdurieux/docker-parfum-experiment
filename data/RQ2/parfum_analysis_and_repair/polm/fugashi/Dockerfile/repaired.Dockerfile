FROM quay.io/pypa/manylinux2014_x86_64

RUN git clone --depth=1 https://github.com/taku910/mecab.git && \
    cd mecab/mecab && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-utf8-only && \
    make && \
    make install
