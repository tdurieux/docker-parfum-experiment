FROM centos:7

RUN yum install -y epel-release && \
    yum install -y \
    "@Development Tools" \
    cairo-devel \
    firefox \
    giflib-devel \
    httpd \
    libjpeg-turbo-devel \
    java-1.8.0-openjdk \
    git \
    stow \
    which \
    xorg-x11-server-Xvfb \
    wget \
    libffi-devel \
    openssl-devel \
    xz && rm -rf /var/cache/yum
RUN cd /usr/src && \
    wget https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz  && \
    tar xzf Python-3.9.4.tgz && \
    rm Python-3.9.4.tgz && \
    cd Python-3.9.4 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations && \
    make altinstall && \
    ln -sf /usr/local/bin/python3.9 /usr/local/bin/python3 && \
    python3 -V && \
    curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    python3 -m ensurepip && \
    pip install --no-cache-dir --upgrade pip && \
    pip --version
RUN mkdir -p /usr/local/nvm
ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=16.15.1
RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install v${NODE_VERSION} && \
    nvm use v${NODE_VERSION} && \
    nvm alias default v${NODE_VERSION}

ENV PATH="${NVM_DIR}/versions/node/v${NODE_VERSION}/bin/:${PATH}"

WORKDIR /build
# Only what is needed to run the development server and run the Selenium tests
RUN mkdir -p /build/node_modules && \
    npm install \
    chromedriver \
    express \
    geckodriver \
    selenium-server-standalone-jar \
    nightwatch && npm cache clean --force;

VOLUME /build/node_modules
VOLUME /build/.python

EXPOSE 80
CMD  tail -f /dev/null


