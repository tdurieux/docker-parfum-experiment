FROM centos:6.8

RUN yum -y update &&\
    yum install -y \
        zlib-devel \
        bzip2-devel \
        openssl-devel \
        xz \
        wget \
        gcc \
        zip \
        unzip \
        ImageMagick \
        csh \
        compat-libgfortran-41 \
        util-linux \
        bc \
        perl \
    && \
    wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tar.xz && \
    xz -d Python-2.7.8.tar.xz && \
    tar -xvf Python-2.7.8.tar && \
    cd Python-2.7.8 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && \
    make && \
    make install && \
    cd .. && \
    rm -rf Python-2.7.8* && \
    wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz && \
    tar -xvf setuptools-1.4.2.tar.gz && \
    cd setuptools-1.4.2 && \
    python setup.py install && \
    cd .. && \
    rm -rf setuptools-1.4.2* && \
    ( curl -f -s https://bootstrap.pypa.io/get-pip.py | python -) && \
    pip install --no-cache-dir \
        docopt \
        lxml \
        numpy \
        matplotlib \
        requests \
    && \
    yum -y remove \
        gcc \
        wget \
    && \
    yum -y clean all && rm -rf /var/cache/yum
