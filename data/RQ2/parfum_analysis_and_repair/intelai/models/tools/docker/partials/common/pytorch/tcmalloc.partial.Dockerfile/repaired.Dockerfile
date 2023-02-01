RUN source activate pytorch && \
    wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.7.90/gperftools-2.7.90.tar.gz && \
    tar -xzf gperftools-2.7.90.tar.gz && \
    cd gperftools-2.7.90 && \
    mkdir -p /workspace/lib/ && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/workspace/lib/tcmalloc/ && \
    make && \
    make install && rm gperftools-2.7.90.tar.gz
