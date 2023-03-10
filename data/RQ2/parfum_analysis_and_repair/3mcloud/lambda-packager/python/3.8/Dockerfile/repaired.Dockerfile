FROM amazonlinux:2

ENV PYTHON_VERSION 3.8.12
ENV PYTHON3_ALIAS python3.8

RUN yum -y groupinstall "Development Tools" \
    && yum -y install git \
    autoconf-archive \
    automake \
    bzip2-devel \
    libffi-devel \
    libressl-dev \
    openssl-devel \
    postgresql-dev \
    sqlite-devel \
    wget \
    which \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar xzf Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} && autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations && make altinstall \
    && cd .. \
    && rm Python-${PYTHON_VERSION}.tgz \
    && ln -s $(which ${PYTHON3_ALIAS}) /usr/bin/python3 \
    && ${PYTHON3_ALIAS} -m pip install --upgrade pip \
    && ${PYTHON3_ALIAS} -m pip install requirement-walker==0.0.9 PyYAML jsonschema \
    && curl -f -sSL https://install.python-poetry.org | python3 - \
    && ln -s /root/.local/bin/poetry /usr/bin/poetry

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY entrypoint.py /entrypoint.py
RUN chmod +x /entrypoint.py

CMD ["/entrypoint.sh"]
