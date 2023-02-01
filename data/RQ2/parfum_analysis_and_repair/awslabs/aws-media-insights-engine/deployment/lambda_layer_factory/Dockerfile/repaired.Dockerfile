FROM amazonlinux

WORKDIR /
RUN yum update -y
RUN yum install gcc gcc-c++ openssl-devel bzip2-devel libffi-devel wget tar gzip zip make -y && rm -rf /var/cache/yum

# Install Python 3.9
WORKDIR /
RUN wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tgz
RUN tar -xzf Python-3.9.0.tgz && rm Python-3.9.0.tgz
WORKDIR /Python-3.9.0
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make install

# Install Python 3.8
WORKDIR /
RUN wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
RUN tar -xzf Python-3.8.0.tgz && rm Python-3.8.0.tgz
WORKDIR /Python-3.8.0
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make install

# Install Python 3.7
WORKDIR /
RUN wget https://www.python.org/ftp/python/3.7.5/Python-3.7.5.tgz
RUN tar -xzvf Python-3.7.5.tgz && rm Python-3.7.5.tgz
WORKDIR /Python-3.7.5
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make install

# Install Python 3.6
WORKDIR /
RUN wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz
RUN tar -xzvf Python-3.6.9.tgz && rm Python-3.6.9.tgz
WORKDIR /Python-3.6.9
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make install

# Install Python packages and build zip files at runtime
WORKDIR /
RUN mkdir -p /packages/lambda_layer-python-3.9/python/lib/python3.9/site-packages
RUN mkdir -p /packages/lambda_layer-python-3.8/python/lib/python3.8/site-packages
RUN mkdir -p /packages/lambda_layer-python-3.7/python/lib/python3.7/site-packages
RUN mkdir -p /packages/lambda_layer-python-3.6/python/lib/python3.6/site-packages
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
