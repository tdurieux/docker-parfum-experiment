FROM fedora:latest

RUN yum install -y \
    cmake \
    gcc-c++ \
    qt5-qtbase-devel \
    qt5-qtcharts-devel \
    qt5-qtdeclarative-devel \
    qt5-qtx11extras-devel \
    qt5-qtsvg-devel \
    libXext-devel \
    python3-devel \
    muParser-devel && rm -rf /var/cache/yum

COPY . /src
WORKDIR /build
RUN rm -rf * && cmake /src && make
