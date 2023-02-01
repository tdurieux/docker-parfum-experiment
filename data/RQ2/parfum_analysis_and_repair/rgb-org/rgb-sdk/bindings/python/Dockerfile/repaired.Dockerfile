FROM rust:1.47.0-slim-buster

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        cmake \
        g++ \
        git \
        libpcre3-dev \
        libpq-dev \
        libssl-dev \
        libzmq3-dev \
        make \
        perl \
        pkg-config \
        python3-pip \
        wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://freefr.dl.sourceforge.net/project/swig/swig/swig-4.0.1/swig-4.0.1.tar.gz && \
    tar xf swig-*.tar.gz && \
    cd swig-* && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j12 && \
    make install && rm swig-*.tar.gz

COPY bindings/python /rgb-sdk/bindings/python
COPY rust-lib /rgb-sdk/rust-lib

WORKDIR /rgb-sdk/bindings/python

RUN python3 -m pip install --upgrade pip setuptools wheel \
    && python3 setup.py build_ext
