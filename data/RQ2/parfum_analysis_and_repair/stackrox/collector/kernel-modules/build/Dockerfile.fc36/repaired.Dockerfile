FROM fedora:36

RUN dnf update -y || true; \
    dnf install -y \
        binutils \
        cmake \
        make \
        curl \
        flex \
        bison \
        gcc \
        clang \
        llvm \
        g++ \
        elfutils-libelf-devel \
        kmod \
        wget \
        golang-go \
        pkg-config || true ; \
    mkdir -p /output; \
    dnf autoremove -y

COPY build-kos /scripts/
COPY build-wrapper.sh /usr/bin/
COPY prepare-src /usr/bin

WORKDIR /scratch
ENTRYPOINT [ "/bin/bash", "-c" ]