FROM quay.io/pypa/manylinux2010_x86_64

ARG PYPI_PASSWORD

MAINTAINER Dilawar Singh <dilawar.s.rajput@gmail.com>
ENV PATH=/usr/local/bin:$PATH
RUN yum update -y
RUN yum install -y cmake3 wget curl && yum clean all && rm -rf /var/cache/yum
RUN ln -s /usr/bin/cmake3 /usr/local/bin/cmake
RUN ln -s /usr/bin/ctest3 /usr/local/bin/ctest
RUN curl -f -O https://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz \
    && tar xvf gsl-2.4.tar.gz \
    && cd gsl-2.4 \
    && CFLAGS=-fPIC ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-static && make $MAKEOPTS \
    && make install \
    && cd .. && rm gsl-2.4.tar.gz
RUN yum install -y git vim && yum clean all && rm -rf /var/cache/yum
RUN git config --global user.name 'Dilawar Singh' \
    &&  git config --global user.email 'dilawar.s.rajput@gmail.com' \
    && git clone https://github.com/dilawar/vim ~/.vim -b minimal
WORKDIR /root
COPY ./build_wheels.sh /root
COPY ./test_and_upload.sh /root
