# To push this repo, log in as "schani" on DockerHub, and
#   docker tag IMAGE-ID schani/quicktype
#   docker push schani/quicktype

FROM ubuntu:bionic-20220105

ENV workdir /app

RUN mkdir ${workdir}
WORKDIR ${workdir}

RUN apt-get -y update --fix-missing
RUN apt-get -y --no-install-recommends install curl git apt-transport-https --assume-yes && rm -rf /var/lib/apt/lists/*;

# Install Swift
RUN curl -f -o swift.tar.gz https://download.swift.org/swift-4.2.4-release/ubuntu1804/swift-4.2.4-RELEASE/swift-4.2.4-RELEASE-ubuntu18.04.tar.gz
RUN tar -zxf swift.tar.gz && rm swift.tar.gz
RUN rm swift.tar.gz
ENV PATH="${workdir}/swift-4.2.4-RELEASE-ubuntu18.04/usr/bin:${PATH}"

# Add nodejs package source
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y update

# Install stuff
RUN apt-get -y --no-install-recommends install nodejs maven default-jdk clang binutils golang-go --assume-yes && rm -rf /var/lib/apt/lists/*;

# Install .NET core
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
RUN curl -f https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install dotnet-sdk-2.1 --assume-yes && rm -rf /var/lib/apt/lists/*;

# Install Boost for C++
RUN apt-get -y --no-install-recommends install libboost-all-dev --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y update && apt-get -y --no-install-recommends install software-properties-common --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:jonathonf/gcc -y
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install g++-7 --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7
RUN update-alternatives --config gcc

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Pike
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install pike8.0-full --assume-yes && rm -rf /var/lib/apt/lists/*;

# Tool to limit elm-make cores
RUN git clone https://github.com/obmarg/libsysconfcpus.git
RUN cd libsysconfcpus && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

# Ruby
RUN apt-get -y --no-install-recommends install ruby --assume-yes && rm -rf /var/lib/apt/lists/*;
# This must be the same version as what's in `Gemfile.lock`
RUN gem install bundler -v 1.16.1

# Kotlin
RUN echo | openssl s_client -showcerts -servername get.sdkman.io -connect get.sdkman.io:443 2>/dev/null | awk '/-----BEGIN CERTIFICATE-----/, /-----END CERTIFICATE-----/' >> /usr/local/share/ca-certificates/ca-certificates.crt  && update-ca-certificates
RUN curl -f -s https://get.sdkman.io | bash
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install kotlin"
ENV PATH="/root/.sdkman/candidates/kotlin/current/bin:${PATH}"

# Python
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install python3.7 --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.7
RUN pip3.7 install mypy python-dateutil types-python-dateutil

# Dart

RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o /tmp/dart.deb "https://storage.googleapis.com/dart-archive/channels/stable/release/2.10.5/linux_packages/dart_2.10.5-1_amd64.deb" && dpkg -i /tmp/dart.deb && rm /tmp/dart.deb

# Crystal
RUN curl -f -sL "https://keybase.io/crystal/pgp_keys.asc" | apt-key add -
RUN echo "deb https://dist.crystal-lang.org/apt crystal main" | tee /etc/apt/sources.list.d/crystal.list
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install crystal --assume-yes && rm -rf /var/lib/apt/lists/*;

# Haskell
RUN curl -f -sL "https://get.haskellstack.org/" | sh

ENV PATH="${workdir}/node_modules/.bin:${PATH}"

COPY . .

ENV CI=true
RUN npm install --unsafe-perm && npm cache clean --force;
RUN npm run tslint
