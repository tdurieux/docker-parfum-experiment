FROM cd/jenkins-slave-base

MAINTAINER Michael Sauter <michael.sauter@boehringer-ingelheim.com>

ENV PYTHON_VERSION=3.6.0
ENV INSTALL_PKGS="yum-utils gcc make openssl-devel zlib-devel"

RUN set -x \
    && yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS \
    && yum clean all \
    && rm -rf /var/cache/yum/*

RUN cd /tmp \
    && curl -f -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar xzf Python-${PYTHON_VERSION}.tgz -C / \
    && rm -rf Python-${Python_VERSION}.tgz

RUN cd /Python-${PYTHON_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make altinstall \
    && ln -s /Python-${PYTHON_VERSION}/python /usr/local/sbin/python3 \
    && python3 -V \
    && chmod a+rx /Python-${PYTHON_VERSION} \
    && chmod a+rx /Python-${PYTHON_VERSION}/python \
    && yum remove -y $INSTALL_PKGS

RUN curl -f "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
    && python3 get-pip.py

# Upgrade PIP
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 -V \
    && pip3 install --no-cache-dir virtualenv pycodestyle

# Configure PIP SSL validation
RUN pip config set global.cert /etc/ssl/certs/ca-bundle.crt \
    && pip config list

# Enables default user to access $HOME folder
RUN chgrp -R 0 $HOME && \
    chmod -R g+rw $HOME

