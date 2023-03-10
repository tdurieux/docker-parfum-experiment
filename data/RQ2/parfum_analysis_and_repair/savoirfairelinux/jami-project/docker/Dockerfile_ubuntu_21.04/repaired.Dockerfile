FROM ubuntu:21.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean
RUN apt-get update && \
    apt-get install --no-install-recommends -y -o Acquire::Retries=10 \
        devscripts \
        equivs \
        nodejs \
        gcc-11 \
        g++-11 \
        python-is-python3 \
        wget && rm -rf /var/lib/apt/lists/*;

ADD scripts/prebuild-package-debian.sh /opt/prebuild-package-debian.sh

COPY packaging/rules/debian-qt/control /tmp/builddeps/debian/control
RUN /opt/prebuild-package-debian.sh qt-deps

COPY packaging/rules/debian/control /tmp/builddeps/debian/control
RUN /opt/prebuild-package-debian.sh jami-deps

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 50
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 50

# Install CMake 3.19 for Qt 6
ADD scripts/install-cmake.sh /opt/install-cmake.sh
RUN /opt/install-cmake.sh

ADD scripts/build-package-debian.sh /opt/build-package-debian.sh
CMD ["/opt/build-package-debian.sh"]
