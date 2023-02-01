FROM python:3.8-slim
RUN apt-get update && apt-get -y --no-install-recommends install \
    curl \
    wget \
    git \
    sudo \
    zip \
    unzip \
    libssl-dev \
    libncurses5-dev \
    libsqlite3-dev \
    libreadline-dev \
    zlib1g-dev \
    xz-utils \
    gcc \
    make \
    build-essential \
    libbluetooth-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
RUN wget https://www.python.org/ftp/python/3.5.8/Python-3.5.8.tar.xz; \
    tar xvf Python-3.5.8.tar.xz; rm Python-3.5.8.tar.xz \
    cd Python-3.5.8; \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    make -j4; \
    make install

WORKDIR /root
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py; \
    python3.5 get-pip.py; \
    python3.5 -m pip install --upgrade pip setuptools wheel rpyc==3.3.0 paho-mqtt cython pyserial paho-mqtt pybluez

RUN rm Python-3.5.8.tar.xz; \
    rm -rf Python-3.5.8; \
    apt-get clean; \
    apt-get -y autoremove
