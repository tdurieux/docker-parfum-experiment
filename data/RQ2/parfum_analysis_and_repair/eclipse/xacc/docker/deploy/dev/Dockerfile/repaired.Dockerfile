FROM xacc/ubuntu:20.04
ARG NODE_VERSION=12.18.3
ENV NODE_VERSION $NODE_VERSION
ENV YARN_VERSION 1.22.5
ARG LLVM=14
# use "latest" or "next" version for Theia packages
ARG version=latest

# Optionally build a striped Theia application with no map file or .ts sources.
# Makes image ~150MB smaller when enabled
ARG strip=false
ENV strip=$strip

WORKDIR /home/dev
ADD settings.json /home/dev/.theia/

# More deps (not in the xacc/ubuntu:20.04)
RUN apt-get update && \
    apt-get --no-install-recommends -y install libsecret-1-dev gfortran\
    curl vim  xz-utils \
    && python3 -m pip install --upgrade pip --user \
    && python3 -m pip install setuptools \
    && python3 -m pip install python-language-server flake8 autopep8 \
    cmake ipopo pint numpy scipy pydantic qiskit pylint pyquil cirq matplotlib openfermion pyscf  \
    qsearch qfactor scikit-quant myqlm qlmaas \
    && apt-get install --no-install-recommends -y gpg && rm -rf /var/lib/apt/lists/* \
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
    A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
    ; do \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-key "$key" || \
    gpg --batch --keyserver keys.openpgp.org --recv-key "$key" || \
    gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" ; \
    done \
    && ARCH= && dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    i386) ARCH='x86';; \
    * echo "unsupported  architecture"; exit 1;; \
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
    6A010C5166006599AA17F08146C2130DFD2497F5 \
    ; do \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-key "$key" || \
    gpg --batch --keyserver keys.openpgp.org --recv-key "$key" || \
    gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" ; \
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
    echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal main" > /etc/apt/sources.list.d/llvm.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    clang-tools-$LLVM \
    clangd-$LLVM \
    clang-tidy-$LLVM \
    gdb && \
    ln -s /usr/bin/clang-$LLVM /usr/bin/clang && \
    ln -s /usr/bin/clang++-$LLVM /usr/bin/clang++ && \
    ln -s /usr/bin/clang-cl-$LLVM /usr/bin/clang-cl && \
    ln -s /usr/bin/clang-cpp-$LLVM /usr/bin/clang-cpp && \
    ln -s /usr/bin/clang-tidy-$LLVM /usr/bin/clang-tidy && \
    ln -s /usr/bin/clangd-$LLVM /usr/bin/clangd && \
    rm -rf /var/lib/apt/lists/*

RUN cd /home/dev && git clone --recursive https://github.com/eclipse/xacc && cd xacc && mkdir build && cd build \
    && cmake .. -DXACC_BUILD_EXAMPLES=TRUE \
    && make -j$(nproc) install \
    && cd ../../ && git clone https://github.com/ornl-qci/tnqvm && cd tnqvm && mkdir build && cd build \
    && cmake .. -DXACC_DIR=~/.xacc && make -j$(nproc) install

# Theia application
WORKDIR /home/dev
ARG version=latest
ADD $version.package.json ./package.json

RUN yarn --cache-folder ./ycache && rm -rf ./ycache && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build ;\
    yarn theia download:plugins
EXPOSE 3000
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/home/dev/plugins
ENV PYTHONPATH "${PYTHONPATH}:/root/.xacc"
ENTRYPOINT [ "yarn", "theia", "start", "/home/dev", "--hostname=0.0.0.0" ]
