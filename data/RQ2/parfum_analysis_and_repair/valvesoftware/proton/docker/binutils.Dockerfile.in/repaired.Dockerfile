FROM @PROTONSDK_URLBASE@/build-base-@ARCH@:latest AS build
RUN wget -q @BINUTILS_URLBASE@/@BINUTILS_SOURCE@ \
&& echo '@BINUTILS_SHA256@  @BINUTILS_SOURCE@' | sha256sum -c - \
&& tar xf @BINUTILS_SOURCE@ -C /tmp && rm @BINUTILS_SOURCE@ \
&& cd /tmp/binutils-@BINUTILS_VERSION@ \
&& ./configure --quiet \
  --prefix=/usr \
  --libdir=/usr/lib \
  --host=@ARCH@-linux-gnu \
  --build=@ARCH@-linux-gnu \
  --target=@ARCH@-@TARGET@ \
  --program-prefix=@ARCH@-@TARGET@- \
  --enable-gold \
  --enable-ld=default \
  --enable-lto \
  --enable-static \
  --disable-multilib \
  --disable-nls \
  --disable-plugins \
  --disable-shared \
  --disable-werror \
  --with-gmp \
  --with-isl \
  --with-mpc \
  --with-mpfr \
  --with-system-zlib \
  MAKEINFO=true \
&& make --quiet -j@J@ MAKEINFO=true configure-host \
&& make --quiet -j@J@ MAKEINFO=true LDFLAGS="-static" \
&& make --quiet -j@J@ MAKEINFO=true install-strip DESTDIR=/opt \
&& rm -rf /opt/usr/share/doc /opt/usr/share/info /opt/usr/share/man \
&& rm -rf /tmp/binutils-@BINUTILS_VERSION@
