FROM alpine:latest

RUN apk --no-cache add --virtual .build-dependencies build-base git automake autoconf libtool \
	&& git clone --recursive https://github.com/detomon/bliplay.git bliplay \
	&& ( cd bliplay && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-sdl && make -j 4 install) \
	&& rm -rf bliplay \
	&& apk del .build-dependencies
