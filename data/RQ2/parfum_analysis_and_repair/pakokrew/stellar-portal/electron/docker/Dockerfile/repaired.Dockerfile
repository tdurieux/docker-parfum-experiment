FROM buildpack-deps:yakkety-curl

# rpm is required for FPM to build rpm package
# yasm is required to build p7zip
# osslsigncode to sign windows on Linux

# install modern multi-thread xz
# ldconfig - see 4.6. liblzma.so (or similar) not found when running xz

# python for node-gyp

ENV XZ_VERSION 5.2.2

# we don't use our bundled 7za because it is better to build for specific platform - not generic
ENV USE_SYSTEM_7ZA true
ENV USE_SYSTEM_XORRISO true

ENV DEBUG_COLORS true
ENV FORCE_COLOR true
ENV DEBIAN_FRONTEND noninteractive

RUN curl -f -L https://yarnpkg.com/latest.tar.gz | tar xvz && mv dist yarn && apt-get update -y && apt-get upgrade -y && \
  apt-get install --no-install-recommends -y xvfb git snapcraft qtbase5-dev xorriso bsdtar build-essential autoconf libssl-dev icnsutils libopenjp2-7 graphicsmagick gcc-multilib g++-multilib libgnome-keyring-dev lzip rpm yasm python libcurl3 && \
  curl -f -O http://mirrors.kernel.org/ubuntu/pool/universe/libi/libicns/libicns1_0.8.1-3.1_amd64.deb && dpkg --install libicns1_0.8.1-3.1_amd64.deb && unlink libicns1_0.8.1-3.1_amd64.deb && \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && apt-get install --no-install-recommends -y google-chrome-stable && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  curl -f -L https://tukaani.org/xz/xz-$XZ_VERSION.tar.xz | tar -xJ && cd xz-$XZ_VERSION && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && cd .. && rm -rf xz-$XZ_VERSION && ldconfig && \
  mkdir -p /tmp/7z && curl -f -L https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2 | tar -xj -C /tmp/7z --strip-components 1 && cd /tmp/7z && cp makefile.linux_amd64_asm makefile.machine && make && make install && rm -rf /tmp/7z

WORKDIR /project

# fix error /usr/local/bundle/gems/fpm-1.5.0/lib/fpm/package/freebsd.rb:72:in `encode': "\xE2" from ASCII-8BIT to UTF-8 (Encoding::UndefinedConversionError)
# http://jaredmarkell.com/docker-and-locales/
# http://askubuntu.com/a/601498
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV PATH "/yarn/bin:$PATH"


#Node
RUN curl -f -sL https://deb.nodesource.com/setup_7.x | bash - && apt-get install --no-install-recommends -y nodejs && curl -f -L https://npmjs.org/install.sh | sh && npm cache clean --force && npm config set unsafe-perm true && npm completion >> ~/.bashrc && apt-get clean && rm -rf /var/lib/apt/lists/*

#Wine
RUN dpkg --add-architecture i386 && apt-get update -y && apt-get install -y --no-install-recommends wine32 wine-stable mono-devel ca-certificates-mono && \
apt-get clean && rm -rf /var/lib/apt/lists/*

ENV WINEDEBUG -all,err+all
ENV WINEDLLOVERRIDES winemenubuilder.exe=d

RUN wineboot --init || true
