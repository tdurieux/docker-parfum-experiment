# Docker file that builds a Centos 6 image ready for GRR installation.
#
# To build a new image on your local machine, cd to this file's directory
# and run (note the period at the end):
#
#   docker build -t grrdocker/centos6 -f Dockerfile.centos6 .
#
# A custom Python version is built and installed in /usr/local/bin by this
# script. It is available in the PATH as 'python2.7'. The old (default) Python
# is still available in the PATH as 'python'.

FROM centos:6

LABEL maintainer="grr-dev@googlegroups.com"

WORKDIR /tmp/grrdocker-scratch

# Install pre-requisites for building Python, as well as GRR prerequisites.
RUN yum update -y && yum install -y zlib-devel bzip2-devel ncurses-devel \
  readline-devel tk-devel gdbm-devel db4-devel libpcap-devel \
  xz-devel epel-release python-devel wget which java-1.8.0-openjdk \
  libffi-devel openssl-devel zip git gcc gcc-c++ redhat-rpm-config rpm-build \
  rpm-sign && rm -rf /var/cache/yum

# Install a recent version of sqlite. CentOS-provided one is too old
# for Python 3.
RUN curl -f -sO https://sqlite.org/2017/sqlite-autoconf-3160200.tar.gz && \
  tar xfz sqlite-autoconf-3160200.tar.gz && \
  cd sqlite-autoconf-3160200 && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  make install && \
  cd .. && \
  rm -rf sqlite-autoconf-3160200* && rm sqlite-autoconf-3160200.tar.gz

# Build a recent version of Python 2 from source (Centos 6 has Python 2.6
# installed in /usr/bin). The custom Python version is installed in
# /usr/local/bin
RUN wget https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tgz && \
  tar xzvf Python-2.7.14.tgz && \
  cd Python-2.7.14 && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared --enable-ipv6 --enable-unicode=ucs4 \
    --prefix=/usr/local LDFLAGS="-Wl,-rpath /usr/local/lib" && \
  make && \
  make altinstall && rm Python-2.7.14.tgz

# Install Python 2 pip and virtualenv.
RUN wget https://bootstrap.pypa.io/get-pip.py && \
  python2.7 get-pip.py && \
  pip install --no-cache-dir --upgrade pip virtualenv

# Build Python 3 from source.
RUN wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz && \
  tar xzvf Python-3.6.9.tgz && \
  cd Python-3.6.9 && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared --enable-ipv6 --prefix=/usr/local \
    LDFLAGS="-Wl,-rpath /usr/local/lib" && \
  make && \
  make altinstall && rm Python-3.6.9.tgz

# TSK currently fails with sqlite-devel, so we have to remove it from the Docker container.
RUN yum remove -y sqlite-devel || true

WORKDIR /

RUN rm -rf /tmp/grrdocker-scratch

CMD ["/bin/bash"]
