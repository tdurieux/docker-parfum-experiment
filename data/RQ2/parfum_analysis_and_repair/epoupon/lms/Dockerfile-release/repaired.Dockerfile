FROM	alpine:3.14 AS build

WORKDIR	/tmp/workdir

ARG	PREFIX="/tmp/install"

ARG	BUILD_PACKAGES=" \
	ca-certificates \
	curl \
	bzip2 \
	pkgconfig \
	coreutils \
	autoconf \
	automake \
	libtool \
	g++ \
	make \
	openjpeg-dev \
	libpng-dev \
	nasm \
	yasm \
	curl \
	libogg-dev \
	opus-dev \
	libvorbis-dev \
	lame-dev \
	cmake \
	zlib-dev \
	openssl-dev \
	boost-dev \
	libconfig-dev \
	taglib-dev \
	gtest-dev"

RUN	apk add --no-cache --update ${BUILD_PACKAGES}

# ffmpeg
ARG	FFMPEG_VERSION=4.1.4
RUN \
	DIR=/tmp/ffmpeg && mkdir -p ${DIR} && cd ${DIR} && \
	curl -f -sLO https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
	tar -jx --strip-components=1 -f ffmpeg-${FFMPEG_VERSION}.tar.bz2 && rm ffmpeg-${FFMPEG_VERSION}.tar.bz2

RUN \
	DIR=/tmp/ffmpeg && mkdir -p ${DIR} && cd ${DIR} && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	--prefix=${PREFIX} \
	--disable-autodetect \
	--disable-debug \
	--disable-doc \
	--disable-ffplay \
	--disable-ffprobe \
	--disable-openssl \
	--disable-postproc \
	--disable-pixelutils \
	--disable-network \
	--enable-shared \
	--disable-static \
	--enable-gpl \
	--enable-small \
	--enable-version3 \
	--enable-nonfree \
	--enable-libmp3lame \
	--enable-libopenjpeg \
	--enable-libopus \
	--enable-libvorbis \
	--disable-everything \
	--enable-decoder=aac*,ac3*,alac,als,flac,mp3*,libopus,pcm*,libvorbis,wavpack,wma*,libopenjpg,png \
	--enable-encoder=libmp3lame,libopus,libvorbis \
	--enable-demuxer=aac,aiff,asf,flac,ipod,ogg,matroska,mov,mp3,mp4,wav,wv,webm \
	--enable-muxer=ogg,matroska,mp3,webm \
	--enable-protocol=file,pipe \
	--enable-filter=aresample \
	--extra-libs=-ldl && \
	make && \
	make install && \
	make distclean

# WT
ARG	WT_VERSION=4.7.2
RUN \
	DIR=/tmp/wt && mkdir -p ${DIR} && cd ${DIR} && \
	curl -f -sLO https://github.com/emweb/wt/archive/${WT_VERSION}.tar.gz && \
	tar -x --strip-components=1 -f ${WT_VERSION}.tar.gz && rm ${WT_VERSION}.tar.gz

RUN \
	DIR=/tmp/wt && mkdir -p ${DIR} && cd ${DIR} && \
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_EXAMPLES=OFF -DENABLE_LIBWTTEST=OFF -DCONNECTOR_FCGI=OFF && \
	make && \
	make install

# STB
ARG	STB_VERSION=b42009b3b9d4ca35bc703f5310eedc74f584be58
RUN \
	DIR=/tmp/stb && mkdir -p ${DIR} && cd ${DIR} && \
	curl -f -sLO https://github.com/nothings/stb/archive/${STB_VERSION}.tar.gz && \
	tar -x --strip-components=1 -f ${STB_VERSION}.tar.gz && \
	mkdir -p ${PREFIX}/include/stb && \
	cp ./*.h ${PREFIX}/include/stb && rm ${STB_VERSION}.tar.gz

# LMS
COPY . /tmp/lms/
RUN \
	DIR=/tmp/lms/build && mkdir -p ${DIR} && cd ${DIR} && \
	PKG_CONFIG_PATH=/tmp/install/lib/pkgconfig CXXFLAGS="-I${PREFIX}/include" LDFLAGS="-L${PREFIX}/lib -Wl,--rpath-link=${PREFIX}/lib" cmake /tmp/lms/ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_PREFIX_PATH=${PREFIX} && \
	LD_LIBRARY_PATH=${PREFIX}/lib VERBOSE=1 make && \
	LD_LIBRARY_PATH=${PREFIX}/lib make test && \
	make install && \
	mkdir -p ${PREFIX}/etc/ && \
	cp /tmp/lms/conf/lms.conf ${PREFIX}/etc

# Now copy all the stuff installed in a new folder (/tmp/fakeroot/)
RUN \
	mkdir -p /tmp/fakeroot/bin && \
	for bin in ${PREFIX}/bin/ffmpeg ${PREFIX}/bin/lms*; \
	do \
		strip --strip-all $bin && \
		cp $bin /tmp/fakeroot/bin/; \
	done && \
	for lib in ${PREFIX}/lib/*.so; \
	do \
		strip --strip-all $lib; \
	done && \
	cp -r ${PREFIX}/lib /tmp/fakeroot/lib && \
	cp -r ${PREFIX}/share /tmp/fakeroot/share && \
	rm -rf /tmp/fakeroot/share/doc && \
	rm -rf /tmp/fakeroot/share/man

# Remove useless stuff
RUN \
	rm -rf /tmp/fakeroot/share/Wt/resources/jPlayer \
	rm -rf /tmp/fakeroot/share/Wt/resources/themes

## Release Stage
FROM		alpine:3.14 AS release
LABEL		maintainer="Emeric Poupon <itmfr@yahoo.fr>"

ARG	RUNTIME_PACKAGES=" \
	libssl1.1 \
	libcrypto1.1 \
	openjpeg \
	libpng \
	libogg \
	opus \
	libvorbis \
	lame \
	zlib \
	boost-filesystem \
	boost-program_options \
	boost-system \
	boost-thread \
	libconfig++ \
	taglib"

ARG	LMS_USER=lms
ARG	LMS_GROUP=lms

RUN	apk add --no-cache --update ${RUNTIME_PACKAGES}

RUN	addgroup -S ${LMS_GROUP} && \
	adduser -S -H ${LMS_USER} && \
	adduser ${LMS_USER} ${LMS_GROUP} && \
	mkdir -p /var/lms && chown -R ${LMS_USER}:${LMS_GROUP} /var/lms

VOLUME	/var/lms
VOLUME	/music
VOLUME	/usr/local/etc

USER	${LMS_USER}:${LMS_GROUP}

COPY	--from=build /tmp/fakeroot/ /usr
COPY	--from=build /tmp/fakeroot/share/lms/lms.conf /etc/lms.conf

EXPOSE	5082

ENTRYPOINT	["/usr/bin/lms"]

