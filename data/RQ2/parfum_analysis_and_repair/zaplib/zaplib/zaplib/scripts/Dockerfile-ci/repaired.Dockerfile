FROM rust:1.54

RUN apt update
RUN apt -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN git clone https://github.com/plaurent/gnustep-build && gnustep-build/debian-10-clang-8.0/GNUstep-buildon-debian10.sh
RUN apt install --no-install-recommends -y libatk1.0-0 libatk-bridge2.0-0 libxkbcommon0 && rm -rf /var/lib/apt/lists/*;

COPY ./rust-toolchain.toml ./rust-toolchain.toml
RUN cargo install cargo-zaplib
RUN cargo zaplib install-deps --ci
RUN rustup target add x86_64-pc-windows-msvc
RUN rustup target add x86_64-pc-windows-gnu
RUN rustup target add x86_64-apple-darwin

# Node 16; copied from https://github.com/nodejs/docker-node/blob/5cafbd5b0462317bd024bb281af49585013473cd/16/bullseye/Dockerfile
RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
ENV NODE_VERSION 16.13.2
RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    i386) ARCH='x86';; \
    * echo "unsupported  architecture"; exit 1;; \
  esac \
  # gpg keys listed at https://github.com/nodejs/node#release-keys
  && set -ex \
  && for key in \
    4ED778F539E3634C779C87C6D7062848A1AB005C \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    74F12602B6F1C4E913FAA37AD3A89613643B6201 \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
    108F52B48DB57BB0CC439B2997B01419BD92F80A \
    B9E2F5981AA6E0CD28160D9FF13993A75599653C \
  ; do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  # smoke tests
  && node --version \
  && npm --version
ENV YARN_VERSION 1.22.15
RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  # smoke test
  && yarn --version

# Browserstack; from https://github.com/mtsmfm/BrowserStackLocal/blob/3edea504384a2f49c11a60d823f0eddbc5b15cb9/Dockerfile#L3
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y wget unzip && \
  wget https://www.browserstack.com/browserstack-local/BrowserStackLocal-linux-x64.zip && \
  unzip BrowserStackLocal-linux-x64.zip && \
  chmod +x BrowserStackLocal && \
  rm BrowserStackLocal-linux-x64.zip && \
  mv BrowserStackLocal /usr/local/bin && rm -rf /var/lib/apt/lists/*;

# aws-cli; from https://stackoverflow.com/a/67548876
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        unzip \
        curl \
    && apt-get clean \
    && curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf \
        awscliv2.zip && rm -rf /var/lib/apt/lists/*;
