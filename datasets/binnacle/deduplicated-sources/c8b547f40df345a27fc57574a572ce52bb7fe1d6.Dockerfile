FROM archlinux/base

ARG CXX_COMPILER=g++

RUN sed -i 's/#\[multilib\]/\[multilib\]/; /^\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
RUN pacman --noconfirm -Syu archlinux-keyring
RUN pacman --noconfirm -Syu base-devel gcc gcc-libs git make cmake doxygen graphviz wget clang autoconf libtool

COPY . /gt/gtirb/
RUN rm -rf /gt/gtirb/build /gt/gtirb/CMakeCache.txt /gt/gtirb/CMakeFiles /gt/gtirb/CMakeScripts
RUN mkdir -p /gt/gtirb/build
WORKDIR /gt/gtirb/build
RUN cmake ../  -DCMAKE_CXX_COMPILER=${CXX_COMPILER}
RUN make -j

WORKDIR /gt/gtirb/
ENV PATH=/gt/gtirb/build/bin:$PATH
