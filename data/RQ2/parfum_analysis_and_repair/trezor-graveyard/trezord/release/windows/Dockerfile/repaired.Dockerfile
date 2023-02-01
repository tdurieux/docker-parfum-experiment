# initialize from the image

FROM fedora:24

# update package repositories

RUN dnf update -y

# install tools

RUN dnf install -y cmake make wget
RUN dnf install -y osslsigncode mingw32-nsis

# install dependencies for Windows build

RUN dnf install -y mingw32-boost-static
RUN dnf install -y mingw32-curl
RUN dnf install -y mingw32-libmicrohttpd
RUN dnf install -y mingw32-winpthreads
RUN dnf install -y mingw32-zlib-static

# install dependencies from COPR