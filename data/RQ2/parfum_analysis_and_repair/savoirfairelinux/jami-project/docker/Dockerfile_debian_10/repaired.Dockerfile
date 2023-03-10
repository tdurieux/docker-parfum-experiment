FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y -o Acquire::Retries=10 \
        devscripts \
        apt-utils \
        equivs \
        gcc-8 \
        g++-8 \
        clang \
        clang-tools \
        libarchive-dev \
        wget && rm -rf /var/lib/apt/lists/*;

ADD scripts/prebuild-package-debian.sh /opt/prebuild-package-debian.sh

COPY packaging/rules/debian-qt/control /tmp/builddeps/debian/control
RUN /opt/prebuild-package-debian.sh qt-deps

COPY packaging/rules/debian/control /tmp/builddeps/debian/control
RUN /opt/prebuild-package-debian.sh jami-deps

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 50
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 50
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

# Install CMake 3.19 for Qt 6
ADD scripts/install-cmake.sh /opt/install-cmake.sh
RUN /opt/install-cmake.sh
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

ADD scripts/build-package-debian.sh /opt/build-package-debian.sh

RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz -q -O /tmp/binutils.xz \
    && cd /tmp/ \
    && tar xvf binutils.xz \
    && cd binutils-2.37 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install

CMD ["/opt/build-package-debian.sh"]
