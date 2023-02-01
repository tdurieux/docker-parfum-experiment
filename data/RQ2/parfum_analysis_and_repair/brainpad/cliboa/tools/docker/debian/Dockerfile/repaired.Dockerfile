FROM debian:stable-slim

# Create dirs
RUN mkdir -p /usr/local/cliboa

# Install essential packages
RUN apt update -y && \
    apt install --no-install-recommends -y git \
                   gnupg-agent \
                   libc6-dev \
                   libbz2-dev \
                   libffi-dev \
                   libgdbm-dev \
                   libssl-dev \
                   libsqlite3-dev \
                   openssl \
                   tk-dev \
                   pinentry-curses \
                   python \
                   python3 \
                   python3-pip \
                   vim \
                   virtualenv \
                   wget \
                   zlib1g-dev \
                   libpq-dev && rm -rf /var/lib/apt/lists/*;

# Download multiple python versions which cliboa supports
RUN cd /usr/local/ && \
    wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz && \
    tar -xzvf Python-3.6.9.tgz && \
    rm -rf Python-3.6.9.tgz && \
    wget https://www.python.org/ftp/python/3.8.11/Python-3.8.11.tgz && \
    tar -xzvf Python-3.8.11.tgz && \
    rm -rf Python-3.8.11.tgz && \
    wget https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz && \
    tar -xzvf Python-3.9.6.tgz && \
    rm -rf Python-3.9.6.tgz

# Build multiple python versions which cliboa supports
RUN cd /usr/local/Python-3.6.9 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/bin/python3.6 && \
    make && \
    make altinstall
RUN cd /usr/local/Python-3.8.11 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/bin/python3.8 && \
    make && \
    make altinstall
RUN cd /usr/local/Python-3.9.6 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/bin/python3.9 && \
    make && \
    make altinstall

# Install essential module
RUN pip3 install --no-cache-dir pipenv
