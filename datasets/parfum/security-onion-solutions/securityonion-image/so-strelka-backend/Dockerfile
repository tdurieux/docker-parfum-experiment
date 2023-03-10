FROM ghcr.io/security-onion-solutions/ubuntu:20.04
LABEL maintainer "Security Onion Solutions, LLC"

ARG DEBIAN_FRONTEND=noninteractive
ARG YARA_VERSION=3.11.0
ARG YARA_PYTHON_VERSION=3.11.0

# Copy Strelka files

# Common Ubuntu layer
RUN apt-get update && \
    apt-get --no-install-recommends --no-install-suggests -y install \
        curl \
        ca-certificates \
        build-essential
        
# Install build packages
RUN apt-get install --no-install-recommends -qq \
    automake \
    gcc \
    git \
    libtool \
    make \
    swig \
    python3-dev \
    python3-pip \
    python3-wheel \
# Install runtime packages
    antiword \
    libarchive-dev \
    libfuzzy-dev \
    libimage-exiftool-perl \
    libmagic-dev \
    libssl-dev \
    python3-setuptools \
    redis-server \
    tesseract-ocr \
    unrar \
    upx \
    jq

# Download strelka
RUN mkdir /tmp/strelka && \
    git clone https://github.com/target/strelka /tmp/strelka

# Prepare backend for python build
RUN mkdir /strelka && \
    cp -fr /tmp/strelka/src/python/* /strelka/ && \
    cp -fr /tmp/strelka/build/python/backend/requirements.txt /strelka/ && \
    cp -fr /tmp/strelka/build/python/backend/setup.py /strelka/

# Remove temp strelka directory
RUN rm -rf /tmp/strelka

# Install Python packages
RUN pip3 install -r /strelka/requirements.txt && \
    pip3 install --index-url https://lief-project.github.io/packages --trusted-host lief.quarkslab.com lief && \
# Install YARA
    cd /tmp/ && \
    curl -OL https://github.com/VirusTotal/yara/archive/v$YARA_VERSION.tar.gz && \
    tar -zxvf v$YARA_VERSION.tar.gz && \
    cd yara-$YARA_VERSION/ && \
    ./bootstrap.sh && \
    ./configure --with-crypto --enable-dotnet --enable-magic && \
    make && make install && make check && \
# Install yara-python
    cd /tmp/ && \
    curl -OL https://github.com/VirusTotal/yara-python/archive/v$YARA_PYTHON_VERSION.tar.gz && \
    tar -zxvf v$YARA_PYTHON_VERSION.tar.gz && \
    cd yara-python-$YARA_PYTHON_VERSION/ && \
    python3 setup.py build --dynamic-linking && \
    python3 setup.py install && \
# Install Strelka
    cd /strelka/ && \
    python3 setup.py -q build && \
    python3 setup.py -q install && \
# Remove build packages
    python3 setup.py -q clean --all && \
    rm -rf dist/ strelka.egg-info && \
    pip3 uninstall -y grpcio-tools && \
    apt-get autoremove -qq --purge \
    automake \
    build-essential \
    curl \
    gcc \
    git \
    libtool \
    make \
    python3-dev \
    python3-pip \
    python3-wheel && \
    apt-get purge -qq python3-setuptools  && \
    apt-get clean -qq && \
    rm -rf /var/lib/apt/lists/* /strelka/ /tmp/yara* && \
# Assign permissions to Strelka scan result logging directory
    adduser -u 939 --disabled-password -no-create-home --gecos "" strelka && \
    mkdir /var/log/strelka/ && \
    chown -R 939:939 /var/log/strelka/
USER strelka
