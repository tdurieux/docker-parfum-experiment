ARG MANYLINUX_IMAGE=manylinux2014_x86_64

FROM quay.io/pypa/$MANYLINUX_IMAGE
LABEL authors="Pramod Kumbhar, Fernando Pereira, Alexandru Savulescu"

# install basic packages
RUN yum -y install \
    git \
    wget \
    make \
    vim \
    curl \
    unzip \
    bison \
    autoconf \
    automake \
    openssh-server \
    libtool && rm -rf /var/cache/yum

# required for rpmbuild
RUN yum -y install \
    gettext \
    gcc-c++ \
    help2man \
    rpm-build && rm -rf /var/cache/yum

WORKDIR /root

# newer flex with rpmbuild (manylinux2014 based on Centos7 currently has flex < 2.6)
RUN rpmbuild --rebuild https://vault.centos.org/8-stream/AppStream/Source/SPackages/flex-2.6.1-9.el8.src.rpm \
    && yum -y install rpmbuild/RPMS/*/flex-2.6.1-9.el7.*.rpm \
    && rm -rf rpmbuild && rm -rf /var/cache/yum

RUN wget https://ftpmirror.gnu.org/ncurses/ncurses-6.2.tar.gz \
    && tar -xvzf ncurses-6.2.tar.gz \
    && cd ncurses-6.2 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/nrnwheel/ncurses --without-shared CFLAGS="-fPIC" \
    && make -j install && rm ncurses-6.2.tar.gz

RUN curl -f -L -o mpich-3.3.2.tar.gz https://www.mpich.org/static/downloads/3.3.2/mpich-3.3.2.tar.gz \
    && tar -xvzf mpich-3.3.2.tar.gz \
    && cd mpich-3.3.2 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/nrnwheel/mpich FFLAGS="-w -fallow-argument-mismatch -O2" \
    && make -j install && rm mpich-3.3.2.tar.gz

RUN curl -f -L -o openmpi-4.0.3.tar.gz https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.gz \
    && tar -xvzf openmpi-4.0.3.tar.gz \
    && cd openmpi-4.0.3 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/nrnwheel/openmpi \
    && make -j install && rm openmpi-4.0.3.tar.gz

RUN curl -f -L -o readline-7.0.tar.gz https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz \
    && tar -xvzf readline-7.0.tar.gz \
    && cd readline-7.0 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/nrnwheel/readline --disable-shared CFLAGS="-fPIC" \
    && make -j install && rm readline-7.0.tar.gz

# create readline with ncurses
RUN cd /nrnwheel/readline/lib \
    && ar -x libreadline.a \
    && ar -x ../../ncurses/lib/libncurses.a \
    && ar cq libreadline.a *.o \
    && rm *.o

ENV PATH /nrnwheel/openmpi/bin:$PATH
RUN yum -y install epel-release libX11-devel libXcomposite-devel vim-enhanced && rm -rf /var/cache/yum
RUN yum -y remove ncurses-devel

# Copy Dockerfile for reference
COPY Dockerfile .

# build wheels from there
WORKDIR /root
