FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt upgrade -y && apt install -y \
    bc \
    bison \
    build-essential \
    ccache \
    curl \
    flex \
    g++-multilib \
    gcc-multilib \
    git \
    gnupg \
    gperf \
    imagemagick \
    lib32ncurses5-dev \
    lib32readline-dev \
    lib32z1-dev \
    liblz4-tool \
    libncurses5-dev \
    libsdl1.2-dev \
    libssl-dev \
    libwxgtk3.0-gtk3-dev \
    libxml2 \
    libxml2-utils \
    lzop \
    pngcrush \
    rsync \
    schedtool \
    squashfs-tools \
    xsltproc \
    zip \
    zlib1g-dev \
    python \
    libtinfo5 \
    libncurses5 \
    vim-common \
    wget \
    curl \
    sudo \
    axel \
    nano \
    && rm -rf /var/lib/apt/lists/*

ARG USER_ID
ARG GROUP_ID

RUN groupadd -g ${GROUP_ID:-1000} build &&\
    useradd -l -u ${USER_ID:-1000} -g build build -d /build &&\
    install -d -m 0755 -o build -g build /build

RUN adduser build sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

USER build
ENV BUILDBASE /build
WORKDIR ${BUILDBASE}

RUN git config --global user.email "fake@name.com" && git config --global user.name Fake Name && git config --global color.ui false

RUN axel https://dl.google.com/android/repository/platform-tools-latest-linux.zip \
    && unzip platform-tools-latest-linux.zip -d ${BUILDBASE} \
    && rm platform-tools-latest-linux.zip

RUN axel https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz \
    && tar -C ${BUILDBASE}/ -zxvf openjdk-9.0.4_linux-x64_bin.tar.gz \
    && rm openjdk-9.0.4_linux-x64_bin.tar.gz

RUN mkdir -p ${BUILDBASE}/bin

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ${BUILDBASE}/bin/repo
RUN chmod a+x ${BUILDBASE}/bin/repo

RUN mkdir -p ${BUILDBASE}/android/lineage
ENV TPATH="${BUILDBASE}/platform-tools:${BUILDBASE}/jdk-9.0.4/bin:${BUILDBASE}/bin"
ENV PATH="${TPATH}:${PATH}"
