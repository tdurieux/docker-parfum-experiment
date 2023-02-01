from centos:7
run yum -y install wget gcc make openssl-devel libffi-devel git zlib-devel libjpeg-devel && rm -rf /var/cache/yum
run wget -q https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz && \
    tar -xf $(ls Python*.tar.xz) && \
    rm -f $(ls Python*.tar.xz)
run cd Python* && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && make altinstall && \
    cd .. && \
    rm -rf Python*
run ln -s /usr/local/bin/pip3.7 /usr/local/bin/pip
run pip install --no-cache-dir setuptools --upgrade && \
    pip install --no-cache-dir tox

run python3.7 -V && \
    pip -V && \
    tox --version
