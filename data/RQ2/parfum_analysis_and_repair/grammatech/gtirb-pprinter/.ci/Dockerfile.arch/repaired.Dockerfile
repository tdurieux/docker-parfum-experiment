FROM archlinux/base

RUN pacman -Syu --noconfirm autoconf automake boost capstone clang cmake \
    doxygen fakeroot gcc git libtool make mcpp pkg-config protobuf python3 \
    python-protobuf unzip wget zlib graphviz