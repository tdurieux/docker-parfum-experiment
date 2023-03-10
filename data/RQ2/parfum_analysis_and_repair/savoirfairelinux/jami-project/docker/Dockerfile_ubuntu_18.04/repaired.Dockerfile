FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean
RUN apt-get update && \
    apt-get install --no-install-recommends -y -o Acquire::Retries=10 \
        devscripts \
        equivs \
        curl \
        gcc-8 \
        g++-8 \
        clang \
        clang-tools \
        libarchive-dev \
        software-properties-common \
        wget && rm -rf /var/lib/apt/lists/*;

# nodejs (more recent version needed for building libqt-jami)
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

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

ADD scripts/build-package-debian.sh /opt/build-package-debian.sh
CMD ["/opt/build-package-debian.sh"]
