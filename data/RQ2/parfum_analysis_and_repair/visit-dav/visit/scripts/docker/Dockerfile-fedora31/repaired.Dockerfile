FROM fedora:31
MAINTAINER Eric Brugger <brugger1@llnl.gov>

# fetch build env
ENV TZ=America/Los_Angeles
RUN dnf -y upgrade && dnf -y install \
    git \
    wget \
    bzip2 \
    unzip \
    xz \
    patch \
    hostname \
    subversion \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    make \
    zlib-devel \
    python \
    libICE-devel \
    libSM-devel \
    libxcb-devel \
    libxkbcommon-devel \
    libXext-devel \
    libXrender-devel \
    libXt-devel \
    freetype-devel \
    fontconfig \
    fontconfig-devel \
    autoconf \
    libtool \
    libxml2 \
    libxml2-devel \
    vim \
    emacs \
    bison \
    bison-devel \
    flex \
    flex-devel \
    cpio \
    mesa-libEGL \
    mesa-libEGL-devel \
 && rm -rf /var/lib/apt/lists/*

RUN dnf -y upgrade && dnf -y install libffi-devel && rm -rf /var/lib/apt/lists/*

RUN cd /usr/include && ln -s freetype2 freetype
RUN cd /usr/bin && ln -s bison yacc

RUN groupadd -r visit && useradd -ms /bin/bash --no-log-init -r -g visit visit
USER visit
WORKDIR /home/visit

# Create the third-party directory
RUN mkdir third-party
# Copy build_visit and the script to run it
COPY build_visit3_3_0 /home/visit
COPY run_build_visit_fedora31.sh /home/visit
COPY build_visit_docker_cleanup.py /home/visit
COPY build_test_visit.sh /home/visit
COPY test_visit.py /home/visit
# Build the third party libraries
RUN /bin/bash run_build_visit_fedora31.sh