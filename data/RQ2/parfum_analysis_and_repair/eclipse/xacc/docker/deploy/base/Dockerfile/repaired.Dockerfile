FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
ARG GITHUB_TOKEN
ARG NODE_VERSION=12.0.0
ENV NODE_VERSION $NODE_VERSION
ENV YARN_VERSION 1.13.0

# use "latest" or "next" version for Theia packages
ARG version=latest

# Optionally build a striped Theia application with no map file or .ts sources.
# Makes image ~150MB smaller when enabled
ARG strip=false
ENV strip=$strip

WORKDIR /home/dev
ADD settings.json /home/dev/.theia/

#Common deps
RUN apt-get update && \
    apt-get --no-install-recommends -y install build-essential libsecret-1-dev \
                       curl \
                       git \
                       python python3 \
                       libpython3-dev \
                       python3-pip \
                       libblas-dev liblapack-dev \
                       libcurl4-openssl-dev libssl-dev \
                       vim gcc-8 g++-8 gfortran-8 \
                       wget \
                       xz-utils && python3 -m pip pip install --upgrade --user \
                       && python3 -m pip install setuptools \
                       && python3 -m pip install python-language-server flake8 autopep8 \
                                cmake ipopo pint numpy scipy pydantic qiskit pylint pyquil cirq matplotlib \
    && apt-get install --no-install-recommends -y gpg && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 50 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 50 \
    && update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-8 50 \

#Install node and yarn
#From: https://github.com/nodejs/docker-node/blob/6b8d86d6ad59e0d1e7a94cec2e909cad137a028f/8/Dockerfile
# gpg keys listed at https://github.com/nodejs/node#release-keys

    && set -ex \
    && for key in \
    4ED778F539E3634C779C87C6D7062848A1AB005C \
    B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    A48C2BEE680E841632CD4E44F07496B3EB3C1762; do \
    

    gpg --batch --keyserver ipv4.ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
   done \


    && ARCH= && dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    i386) ARCH='x86';; \
    *) echo "unsupported architecture"; exit 1 ;; \
    esac \
    && curl -f -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
    && curl -f -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \


    && set -ex \
    && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5; do \
    

    gpg --batch --keyserver ipv4.ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
   done \

    && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
    && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
    && mkdir -p /opt/yarn \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \

#C/C++ Developer tools
# install clangd and clang-tidy from the public LLVM PPA (nightly build / development version)
# and also the GDB debugger, cmake from the Ubuntu repos

    && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-12 main" > /etc/apt/sources.list.d/llvm.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
                       clang-tools-12 \
                       clangd-12 \
                       clang-tidy-12 \
                       gdb && \
    ln -s /usr/bin/clangd-12 /usr/bin/clangd && \
    ln -s /usr/bin/clang-tidy-12 /usr/bin/clang-tidy && \
    rm -rf /var/lib/apt/lists/*