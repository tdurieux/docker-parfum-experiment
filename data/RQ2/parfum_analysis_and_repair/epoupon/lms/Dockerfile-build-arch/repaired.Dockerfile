FROM archlinux:latest

ARG BUILD_PACKAGES="\
	clang \
	cmake \
	boost \
	ffmpeg \
	gtest \
	graphicsmagick \
	libconfig \
	make \
	pkgconfig \
	taglib \
	wt"

RUN	pacman -Syy
RUN pacman -S --noconfirm ${BUILD_PACKAGES}

# LMS
COPY . /tmp/lms/
ARG LMS_BUILD_TYPE="Release"
RUN \
	DIR=/tmp/lms/build && mkdir -p ${DIR} && cd ${DIR}  && \
		cmake /tmp/lms/ -DCMAKE_BUILD_TYPE=${LMS_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=/usr && \
		VERBOSE=1 make -j$(nproc) && \
		make test