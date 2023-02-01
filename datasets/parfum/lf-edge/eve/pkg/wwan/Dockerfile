FROM lfedge/eve-alpine:6.7.0 as build
ENV BUILD_PKGS automake autoconf gettext gettext-dev git pkgconfig \
               libtool libc-dev linux-headers gcc make glib-dev \
               autoconf-archive patch cmake
ENV PKGS alpine-baselayout musl-utils ppp jq glib
RUN eve-alpine-deploy.sh

WORKDIR /
RUN git clone https://git.openwrt.org/project/libubox.git
RUN git clone https://github.com/json-c/json-c.git
RUN git clone https://gitlab.freedesktop.org/mobile-broadband/libqmi
RUN git clone https://gitlab.freedesktop.org/mobile-broadband/libmbim
RUN git clone https://github.com/inotify-tools/inotify-tools
RUN git clone https://github.com/npat-efault/picocom.git

WORKDIR /json-c
RUN git checkout ed54353d && ./autogen.sh && ./configure && make install

WORKDIR /libubox
RUN git checkout 7da66430 && cmake . -DBUILD_LUA=OFF -DBUILD_EXAMPLES=OFF && make install

WORKDIR /libmbim
RUN git checkout 1.24.2
COPY 0001-produce-json-output.patch .
RUN patch -p1 < 0001-produce-json-output.patch
RUN ./autogen.sh && ./configure --prefix=/usr && make && make install

WORKDIR /libqmi
RUN git checkout 1.26.2 && ./autogen.sh --without-udev && ./configure --prefix=/usr --without-udev --enable-mbim-qmux && make && make install

WORKDIR /inotify-tools
RUN git checkout 3.20.11.0 && ./autogen.sh && ./configure --prefix=/usr && make && make install

WORKDIR /picocom
# Need this patch to build with musl: https://github.com/npat-efault/picocom/commit/1acf1ddabaf3576b4023c4f6f09c5a3e4b086fb8
RUN git checkout 1acf1ddabaf3576b && make && strip picocom && cp picocom /usr/bin/

RUN strip /usr/bin/*cli /usr/libexec/*proxy /usr/lib/libmbim*.so.* /usr/lib/libqmi*.so.* /usr/lib/libinotifytools*.so.*

# second stage (new-ish Docker feature) for smaller image
FROM scratch

ENTRYPOINT []
WORKDIR /
COPY --from=build /out/ /
COPY --from=build /usr/bin/qmicli /usr/bin/mbimcli /usr/bin/inotify* /usr/bin/picocom /bin/
COPY --from=build /usr/lib/libmbim*.so.[0-9] /usr/lib/libqmi*.so.[0-9] /usr/lib/
COPY --from=build /usr/lib/libinotifytools*.so.[0-9] /usr/lib/
COPY --from=build /usr/libexec/*proxy /usr/libexec/
COPY usr/ /usr/
COPY etc/ /etc/
CMD ["/usr/bin/wwan-init.sh"]
