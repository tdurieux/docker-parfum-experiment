FROM quay.io/pypa/manylinux2010_x86_64
WORKDIR /tick

RUN yum update -y && yum install -y zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel pcre-devel atlas-devel && rm -rf /var/cache/yum

ENV PATH="/root/.pyenv/bin:$PATH" SWIG_VER=4.0.1

# Installing swig
RUN curl -f -O https://kent.dl.sourceforge.net/project/swig/swig/swig-${SWIG_VER}/swig-${SWIG_VER}.tar.gz && tar -xf swig-${SWIG_VER}.tar.gz && \
	cd swig-${SWIG_VER} && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-pcre && make -j4 && make install && \
	rm -rf swig-${SWIG_VER}.tar.gz swig-${SWIG_VER}

# Installing cmake
RUN curl -f -O https://cmake.org/files/v3.15/cmake-3.15.3.tar.gz && tar -xf cmake-3.15.3.tar.gz && \
    ( cd cmake-3.15.3 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && gmake -j4 && gmake install) && \
    rm -rf cmake-3.15.3.tar.gz cmake-3.15.3

# Installing googletest
RUN git clone https://github.com/google/googletest.git && \
	(cd googletest && mkdir -p build && cd build && cmake .. && make -j4 && make install) && \
	rm -rf googletest

LABEL maintainer "soren.poulsen@polytechnique.edu"