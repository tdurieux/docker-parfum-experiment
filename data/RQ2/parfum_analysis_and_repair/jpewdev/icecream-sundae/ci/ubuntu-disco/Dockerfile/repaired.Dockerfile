FROM ubuntu:disco

RUN apt-get -y update && apt-get -y --no-install-recommends install \
    clang \
    g++ \
    libcap-ng-dev \
    libglib2.0-dev \
    libicecc-dev \
    liblzo2-dev \
    libncursesw5-dev \
    meson \
    ninja-build && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /root/icecream-sundae/builddir
COPY . /root/icecream-sundae/
WORKDIR /root/icecream-sundae/builddir/
