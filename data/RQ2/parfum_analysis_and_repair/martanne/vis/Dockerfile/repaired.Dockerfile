# Run 'make docker' to build a statically linked vis executable!
FROM i386/alpine:3.16
RUN apk update && apk add --upgrade --no-cache \
	acl-dev \
	acl-static \
	ca-certificates \
	fortify-headers \
	gcc \
	libtermkey-dev \
	lua5.3-dev \
	lua5.3-lpeg \
	lua-lpeg-dev \
	make \
	musl-dev \
	ncurses-dev \
	ncurses-static \
	tar \
	wget \
	xz \
	xz-dev
RUN sed -i 's/Libs: /Libs: -L${INSTALL_CMOD} /' /usr/lib/pkgconfig/lua5.3.pc
RUN mv /usr/lib/lua/5.3/lpeg.a /usr/lib/lua/5.3/liblpeg.a
RUN sed -i 's/-ltermkey/-ltermkey -lunibilium/' /usr/lib/pkgconfig/termkey.pc
# TODO contribute a proper libuntar package to Alpine