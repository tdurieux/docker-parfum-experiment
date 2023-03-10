FROM centos:7
MAINTAINER Name rich@cs.ucsb.edu
RUN sed 's/$kvariant/rpi2/' /etc/yum.repos.d/CentOS-armhfp-kernel.repo > /etc/yum.repos.d/new-k.repo
RUN cp /etc/yum.repos.d/new-k.repo /etc/yum.repos.d/CentOS-armhfp-kernel.repo
RUN rm -f /etc/yum.repos.d/new-k.repo
RUN echo "[epel]" > /etc/yum.repos.d/epel-unsigned.repo
RUN echo "name=Epel rebuild for armhfp" >> /etc/yum.repos.d/epel-unsigned.repo
RUN echo "baseurl=https://armv7.dev.centos.org/repodir/epel-pass-1/" >> /etc/yum.repos.d/epel-unsigned.repo
RUN echo "enabled=1" >> /etc/yum.repos.d/epel-unsigned.repo
RUN echo "gpgcheck=0" >> /etc/yum.repos.d/epel-unsigned.repo
RUN yum -y update && \
yum -y install zeromq-devel install blas blas-devel \
	gcc \
	autoconf \
	gdb \
	git \
	make \
	cmake \ 
	libtool \
	uuid-devel && rm -rf /var/cache/yum
WORKDIR /root
RUN mkdir -p src
WORKDIR /root/src
RUN git clone git://github.com/zeromq/czmq.git
WORKDIR /root/src/czmq
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && ldconfig
WORKDIR /
ENV LAPACK=lapack-3.8.0
RUN mkdir ${LAPACK}
RUN /bin/bash -l -c '\
    curl -sSL "http://www.netlib.org/lapack/${LAPACK}.tar" | \
    tar xz && cd ${LAPACK} && \
    cp make.inc.example make.inc && \
    make blaslib && \
    make lapacklib -j 8 && cp liblapack.a /lib64 && \
    cp liblapack.a /usr/local/lib && cp librefblas.a /usr/local/lib && \
    cd LAPACKE && make && cd .. && cp liblapacke.a /usr/local/lib && \
    cd ../ && rm -rf ${LAPACK}'
