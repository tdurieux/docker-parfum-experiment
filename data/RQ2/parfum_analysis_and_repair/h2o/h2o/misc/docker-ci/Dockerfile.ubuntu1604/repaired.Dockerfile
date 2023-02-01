FROM ubuntu:16.04

RUN apt-get --yes update

# huge packages go first (for better cacheability)
RUN apt-get install --no-install-recommends --yes bison ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes php-cgi && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes time && rm -rf /var/lib/apt/lists/*;

# tools for building and testing
RUN apt-get install --no-install-recommends --yes apache2-utils cmake cmake-data git memcached netcat-openbsd nghttp2-client redis-server wget sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes libev-dev libc-ares-dev libssl-dev libuv1-dev zlib1g-dev libbrotli-dev dnsutils && rm -rf /var/lib/apt/lists/*;

# clang-4.0 for fuzzing
RUN apt-get install --no-install-recommends -y clang-4.0 && rm -rf /var/lib/apt/lists/*;
ENV PATH=/usr/lib/llvm-4.0/bin:$PATH

ARG OPENSSL_URL="https://www.openssl.org/source/"
# openssl 1.1.0
ARG OPENSSL_VERSION="1.1.0i"
ARG OPENSSL_SHA1="6713f8b083e4c0b0e70fd090bf714169baf3717c"
RUN wget ${OPENSSL_URL}openssl-${OPENSSL_VERSION}.tar.gz
RUN ( echo "${OPENSSL_SHA1} openssl-${OPENSSL_VERSION}.tar.gz" | sha1sum -c - && tar xf openssl-${OPENSSL_VERSION}.tar.gz) && rm openssl-${OPENSSL_VERSION}.tar.gz
RUN (cd openssl-${OPENSSL_VERSION} && \
	./config --prefix=/opt/openssl-1.1.0 --openssldir=/opt/openssl-1.1.0 shared enable-ssl3 enable-ssl3-method enable-weak-ssl-ciphers && \
	make -j $(nproc) && make -j install_sw install_ssldirs)

# openssl 1.1.1
ARG OPENSSL_VERSION="1.1.1c"
ARG OPENSSL_SHA1="71b830a077276cbeccc994369538617a21bee808"
RUN wget ${OPENSSL_URL}openssl-${OPENSSL_VERSION}.tar.gz
RUN ( echo "${OPENSSL_SHA1} openssl-${OPENSSL_VERSION}.tar.gz" | sha1sum -c - && tar xf openssl-${OPENSSL_VERSION}.tar.gz) && rm openssl-${OPENSSL_VERSION}.tar.gz
RUN (cd openssl-${OPENSSL_VERSION} && \
	./config --prefix=/opt/openssl-1.1.1 --openssldir=/opt/openssl-1.1.1 shared enable-ssl3 enable-ssl3-method enable-weak-ssl-ciphers && \
	make -j $(nproc) && make -j install_sw install_ssldirs)

# nghttp2 and h2load
ARG NGHTTP2_VERSION="1.30.0"
ARG NGHTTP2_SHA256="089afb4c22a53f72384b71ea06194be255a8a73b50b1412589105d0e683c52ac"
RUN apt-get install --no-install-recommends --yes autoconf automake autotools-dev libtool pkg-config && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/nghttp2/nghttp2/releases/download/v${NGHTTP2_VERSION}/nghttp2-${NGHTTP2_VERSION}.tar.xz
RUN ( echo "${NGHTTP2_SHA256}  nghttp2-${NGHTTP2_VERSION}.tar.xz" | sha256sum -c -)
RUN tar xf nghttp2-${NGHTTP2_VERSION}.tar.xz && rm nghttp2-${NGHTTP2_VERSION}.tar.xz
RUN cd nghttp2-${NGHTTP2_VERSION} && autoreconf -i && automake && autoconf && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-app --prefix=/usr/local && make && make install
ENV LD_LIBRARY_PATH="/usr/local/lib"

# curl with http2 support
RUN wget --no-verbose -O - https://curl.haxx.se/download/curl-7.81.0.tar.gz | tar xzf -
RUN ( cd curl-7.81.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --with-openssl --without-brotli --with-nghttp2 --disable-shared && make && make install)

# cpan modules
RUN apt-get install --no-install-recommends --yes cpanminus && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes libfcgi-perl libfcgi-procmanager-perl libipc-signal-perl libjson-perl liblist-moreutils-perl libplack-perl libscope-guard-perl libtest-exception-perl libwww-perl libio-socket-ssl-perl && rm -rf /var/lib/apt/lists/*;
ENV PERL_CPANM_OPT="--mirror https://cpan.metacpan.org/"
RUN cpanm -n Test::More Starlet Protocol::HTTP2 Net::DNS::Nameserver Test::TCP

# h2spec
RUN curl -f -Ls https://github.com/summerwind/h2spec/releases/download/v2.6.0/h2spec_linux_amd64.tar.gz | tar zx -C /usr/local/bin

# use dumb-init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 \
 && chmod +x /usr/local/bin/dumb-init

# komake
RUN wget -O /usr/local/bin/komake https://raw.githubusercontent.com/kazuho/komake/main/komake && chmod +x /usr/local/bin/komake

# create user
RUN useradd --create-home ci
RUN echo 'ci ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
WORKDIR /home/ci
USER ci

ENTRYPOINT ["/usr/local/bin/dumb-init", "--rewrite", "1:0"]
