FROM clux/muslrust as base

RUN apt-get update && apt-get install -y --no-install-recommends bzip2 gnupg && rm -rf /var/lib/apt/lists/*

ENV TARGET "x86_64-unknown-linux-musl"

# Optional localization support:
# To enable uncomment the following commands, replace "--disable-nls" with
# "--with-libintl-prefix=$PREFIX", and add ":intl" to the LIBGPG_ERROR_LIBS
# environment variable.
# ARG GETTEXT_VER=0.21
# WORKDIR /usr/src
# ADD https://ftp.gnu.org/gnu/gettext/gettext-${GETTEXT_VER}.tar.xz ./
# RUN tar -xjf gettext-${GETTEXT_VER}.tar.xz
# WORKDIR gettext-$GETTEXT_VER
# RUN ./configure --host "$TARGET" --prefix="$PREFIX" --with-pic --enable-fast-install --disable-dependency-tracking --without-emacs --disable-java --disable-csharp --disable-c++
# RUN make -j$(nproc) install

ARG LIBGPG_ERROR_VER=1.42
WORKDIR /usr/src
ADD https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-${LIBGPG_ERROR_VER}.tar.bz2 ./
RUN tar -xjf libgpg-error-${LIBGPG_ERROR_VER}.tar.bz2 && rm libgpg-error-${LIBGPG_ERROR_VER}.tar.bz2
WORKDIR libgpg-error-$LIBGPG_ERROR_VER
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host "$TARGET" --prefix="$PREFIX" --with-pic --enable-fast-install --disable-dependency-tracking --enable-static --disable-shared --disable-nls --disable-doc --disable-languages --disable-tests
RUN make -j$(nproc) install

ARG LIBASSUAN_VER=2.5.5
WORKDIR /usr/src
ADD https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-${LIBASSUAN_VER}.tar.bz2 ./
RUN tar -xjf libassuan-${LIBASSUAN_VER}.tar.bz2 && rm libassuan-${LIBASSUAN_VER}.tar.bz2
WORKDIR libassuan-$LIBASSUAN_VER
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host "$TARGET" --prefix="$PREFIX" --with-pic --enable-fast-install --disable-dependency-tracking --enable-static --disable-shared --disable-doc --with-gpg-error-prefix="$PREFIX"
RUN make -j$(nproc) install

ARG GPGME_VER=1.16.0
WORKDIR /usr/src
ADD https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-${GPGME_VER}.tar.bz2 ./
RUN tar -xjf gpgme-${GPGME_VER}.tar.bz2 && rm gpgme-${GPGME_VER}.tar.bz2
WORKDIR gpgme-$GPGME_VER
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host "$TARGET" --prefix="$PREFIX" --with-pic --enable-fast-install --disable-dependency-tracking --enable-static --disable-shared --disable-languages --disable-gpg-test --with-gpg-error-prefix="$PREFIX" --with-libassuan-prefix="$PREFIX"
RUN make -j$(nproc) install

FROM base
WORKDIR /root/ws
COPY ./ ./
ENV LIBGPG_ERROR_INCLUDE "$PREFIX/include"
ENV LIBGPG_ERROR_LIB_DIR "$PREFIX/lib"
ENV LIBGPG_ERROR_LIBS "gpg-error"
ENV LIBGPG_ERROR_STATIC yes
ENV GPGME_INCLUDE "$PREFIX/include"
ENV GPGME_LIB_DIR "$PREFIX/lib"
ENV GPGME_LIBS "gpgme:assuan"
ENV GPGME_STATIC yes
CMD cargo test
