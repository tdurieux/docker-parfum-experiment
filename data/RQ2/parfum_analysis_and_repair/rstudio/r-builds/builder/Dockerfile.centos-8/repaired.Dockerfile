FROM rockylinux:8

ENV OS_IDENTIFIER centos-8

RUN dnf -y upgrade \
    && dnf -y install dnf-plugins-core \
    && dnf config-manager --set-enabled powertools \
    && dnf -y install \
    autoconf \
    automake \
    bzip2-devel \
    cairo-devel \
    gcc-c++ \
    gcc-gfortran \
    java-1.8.0-openjdk-devel \
    java-1.8.0-openjdk-headless \
    libICE-devel \
    libSM-devel \
    libX11-devel \
    libXmu-devel \
    libXt-devel \
    libcurl-devel \
    libicu-devel \
    libjpeg-devel \
    libpng-devel \
    libtiff-devel \
    libtool \
    make \
    ncurses-devel \
    pango-devel \
    pcre-devel \
    pcre2-devel \
    python36 \
    python3-pip \
    readline-devel \
    rpm-build \
    ruby \
    ruby-devel \
    tcl-devel \
    tex \
    texinfo-tex \
    texlive-collection-latexrecommended \
    tk-devel \
    valgrind-devel \
    which \
    wget \
    xz-devel \
    zlib-devel \
    && dnf clean all

# Install AWS CLI.
RUN pip3 install --no-cache-dir awscli --upgrade --user \
    && ln -s /root/.local/bin/aws /usr/bin/aws

# Pin fpm to avoid git dependency in 1.12.0
RUN gem install fpm:1.11.0

RUN chmod 0777 /opt

# Configure flags for CentOS 8 that don't use the defaults in build.sh
ENV CONFIGURE_OPTIONS="\
    --enable-R-shlib \
    --with-tcltk \
    --enable-memory-profiling \
    --with-x \
    --with-system-valgrind-headers \
    --with-tcl-config=/usr/lib64/tclConfig.sh \
    --with-tk-config=/usr/lib64/tkConfig.sh \
    --enable-prebuilt-html"

# RHEL 8 doesn't have the inconsolata font, so override the defaults.
ENV R_RD4PDF="times,hyper"

COPY package.centos-8 /package.sh
COPY build.sh .
ENTRYPOINT ./build.sh
