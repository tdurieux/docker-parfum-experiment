FROM @PROTONSDK_URLBASE@/build-base-@ARCH@:latest AS build
RUN wget -q @MINGW_URLBASE@/@MINGW_SOURCE@ \
&& echo '@MINGW_SHA256@  @MINGW_SOURCE@' | sha256sum -c - \
&& tar xf @MINGW_SOURCE@ -C /tmp && rm @MINGW_SOURCE@ \
&& cd /tmp/mingw-w64-v@MINGW_VERSION@/mingw-w64-headers \
&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --quiet \
  --prefix=/usr/@ARCH@-w64-mingw32/ \
  --host=@ARCH@-w64-mingw32 \
  --enable-sdk=all \
  --enable-secure-api \
  --enable-idl \
  MAKEINFO=true \
&& make --quiet -j@J@ MAKEINFO=true \
&& make --quiet -j@J@ MAKEINFO=true install-strip DESTDIR=/opt \
&& rm -rf /opt/usr/share/doc /opt/usr/share/info /opt/usr/share/man \
&& rm -rf /tmp/mingw-w64-v@MINGW_VERSION@
