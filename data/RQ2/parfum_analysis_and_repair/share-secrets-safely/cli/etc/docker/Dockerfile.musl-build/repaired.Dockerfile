FROM clux/muslrust:stable

RUN apt-get update && apt-get install --no-install-recommends -y autoconf=2.69-9 && rm -rf /var/lib/apt/lists/*;

ENV GETTEXT_VERSION=0.19.3

RUN curl -f -sL https://ftp.gnu.org/gnu/gettext/gettext-${GETTEXT_VERSION}.tar.gz -o /gettext-${GETTEXT_VERSION}.tar.gz
RUN cd / && tar -xf /gettext-${GETTEXT_VERSION}.tar.gz && rm /gettext-${GETTEXT_VERSION}.tar.gz
RUN cd /gettext-${GETTEXT_VERSION} && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-openmp --without-emacs --disable-java --disable-c++ --enable-fast-install > /dev/null
RUN cd /gettext-${GETTEXT_VERSION} make -j2 > /dev/null && make install > /dev/null

ENV LD_LIBRARY_PATH=/usr/local/lib
