FROM ubuntu

RUN DEBIAN_FRONTEND=noninteractive apt-get update -yy && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yy gcc g++ libz-dev make unzip zip zlib1g-dev clang \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
        cmake \
        automake \
        bison \
        curl \
        file \
        flex \
        git \
        libtool \
        pkg-config \
        texinfo \
        vim \
        wget && rm -rf /var/lib/apt/lists/*;

# Install osxcross
# NOTE: The Docker Hub's build machines run varying types of CPUs, so an image
# built with `-march=native` on one of those may not run on every machine - I
# ran into this problem when the images wouldn't run on my 2013-era Macbook
# Pro.  As such, we remove this flag entirely.
ENV OSXCROSS_SDK_VERSION 10.8
RUN mkdir /opt/osxcross &&                                      \
    cd /opt &&                                                  \
    git clone https://github.com/tpoechtrager/osxcross.git &&   \
    cd osxcross &&                                              \
    ./tools/get_dependencies.sh && \
    curl -f -L -o ./tarballs/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz \
        https://s3.amazonaws.com/andrew-osx-sdks/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz && \
    yes | PORTABLE=true ./build.sh && \
    ./build_gcc.sh

ENV PATH $PATH:/opt/osxcross/target/bin
CMD /bin/bash
