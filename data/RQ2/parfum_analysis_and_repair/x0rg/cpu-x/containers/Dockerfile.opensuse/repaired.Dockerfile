FROM docker.io/opensuse/leap:15 AS build-stage
WORKDIR /CPU-X
ENV APPIMAGE_EXTRACT_AND_RUN=1
ARG DESTDIR=/AppDir
COPY . .
RUN zypper install -y wget patchelf librsvg2-devel file \
	gcc gcc-c++ pkg-config cmake ninja nasm gettext gettext-tools \
	update-desktop-files gtk3 gtk3-devel ncurses ncurses-devel \
	libcpuid14 libcpuid-devel procps procps-devel pciutils pciutils-devel \
	libglfw3 libglfw-devel libOpenCL1 ocl-icd-devel opencl-headers
RUN cmake -S "/CPU-X" -B build -GNinja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr
RUN cmake --build build
RUN cmake --install build
RUN ./scripts/build_appimage.sh "/CPU-X" "${DESTDIR}"