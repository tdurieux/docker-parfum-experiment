# Docker file for JuliaBox
# Tag: julialang/juliaboxpkgdist
# Version:latest

FROM julialang/juliaboxminpkgdist:latest

MAINTAINER Tanmay Mohapatra

# Sundials
RUN apt-get install --no-install-recommends -y \
    libsundials-cvode1 \
    libsundials-cvodes2 \
    libsundials-ida2 \
    libsundials-idas0 \
    libsundials-kinsol1 \
    libsundials-nvecserial0 \
    libsundials-serial \
    libsundials-serial-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# NLopt
RUN apt-get install --no-install-recommends -y \
    libnlopt0 \
    libnlopt-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Ipopt
RUN mkdir ipopt && cd ipopt && wget https://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.1.tgz && \
    tar -xzf Ipopt-3.12.1.tgz && cd Ipopt-3.12.1 && \
    cd ThirdParty/Blas && ./get.Blas && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --disable-shared --with-pic && make install && cd ../.. && \
    cd ThirdParty/Lapack && ./get.Lapack && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --disable-shared --with-pic && make install && cd ../.. && \
    cd ThirdParty/Mumps && ./get.Mumps && cd ../ASL && ./get.ASL && cd ../.. && \
    env LIBS='-lgfortran' ./configure --prefix=/usr/local --enable-dependency-linking coin_skip_warn_cxxflags=yes --with-blas=/usr/local/lib/libcoinblas.a --with-lapack=/usr/local/lib/libcoinlapack.a && \
    make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/ipopt.conf && ldconfig && \
    cd ../.. && \
    rm -rf ipopt && rm Ipopt-3.12.1.tgz

# Cbc
RUN mkdir cbc && cd cbc && wget https://www.coin-or.org/download/source/Cbc/Cbc-2.8.12.tgz && \
    tar -xzf Cbc-2.8.12.tgz && cd Cbc-2.8.12 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --enable-dependency-linking --without-blas --without-lapack --enable-cbc-parallel && \
    make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/cbc.conf && ldconfig && \
    cd ../.. && \
    rm -rf cbc && rm Cbc-2.8.12.tgz

# MPI
RUN apt-get install --no-install-recommends -y \
    openmpi-bin \
    libopenmpi-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Stan
RUN mkdir stan && cd stan && wget https://github.com/stan-dev/cmdstan/releases/download/v2.14.0/cmdstan-2.14.0.tar.gz && \
    tar -xzvf cmdstan-2.14.0.tar.gz && mv cmdstan-2.14.0 /usr/share/cmdstan && \
    (cd /usr/share/cmdstan && make build) && \
    echo "export CMDSTAN_HOME=/usr/share/cmdstan" > /etc/profile.d/cmdstan.sh && \
    chmod 755 /etc/profile.d/cmdstan.sh && \
    cd .. && \
    rm -rf stan && rm cmdstan-2.14.0.tar.gz

# Nemo
RUN apt-get install --no-install-recommends -y \
    m4 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN mkdir mpir && cd mpir && wget https://mpir.org/mpir-2.7.0-alpha11.tar.bz2 && \
    tar -xvf mpir-2.7.0-alpha11.tar.bz2 && cd mpir-2.7.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" M4=/usr/bin/m4 --enable-gmpcompat --disable-static --enable-shared && \
    make && make install && \
    cd ../.. && \
    rm -rf mpir && rm mpir-2.7.0-alpha11.tar.bz2

RUN mkdir mpfr && cd mpfr && wget https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.3.tar.bz2 && \
    tar -xvf mpfr-3.1.3.tar.bz2 && cd mpfr-3.1.3 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-gmp=/usr/local --disable-static --enable-shared && \
    make && make install && \
    cd ../.. && \
    rm -rf mpfr && rm mpfr-3.1.3.tar.bz2

RUN mkdir flint2 && cd flint2 && git clone https://github.com/wbhart/flint2.git && \
    cd flint2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-static --enable-shared --with-mpir --with-mpfr && \
    make && make install && \
    cd ../.. && \
    rm -rf flint2

# RCall
RUN apt-get install --no-install-recommends -y software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 \
    && add-apt-repository -y "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    r-base \
    r-base-dev \
    r-recommended \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD setup_julia.sh /tmp/setup_julia.sh

RUN /tmp/setup_julia.sh
