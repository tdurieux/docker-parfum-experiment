FROM docker.io/fedora:33 AS build-stage
WORKDIR /CPU-X
ENV APPIMAGE_EXTRACT_AND_RUN=1
ARG DESTDIR=/AppDir
COPY . .
RUN dnf install -y wget patchelf librsvg2-devel file \
	gcc gcc-c++ pkgconfig cmake ninja-build nasm gettext \
	gtk3 gtk3-devel ncurses ncurses-libs ncurses-devel libcpuid libcpuid-devel \
	procps-ng procps-ng-devel pciutils pciutils-devel glfw glfw-devel \
	ocl-icd ocl-icd-devel opencl-headers
RUN cmake -S "/CPU-X" -B build -GNinja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr
RUN cmake --build build
RUN cmake --install build
RUN ./scripts/build_appimage.sh "/CPU-X" "${DESTDIR}"