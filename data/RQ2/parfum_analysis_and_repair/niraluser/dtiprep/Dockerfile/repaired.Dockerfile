FROM centos:centos7
RUN yum update -y &&\
	yum groupinstall "Development Tools" -y &&\
	yum install python-devel -y &&\
	yum install qt5-qtbase-devel -y &&\
	yum install qt4-devel -y &&\
	yum install wget -y &&\
	yum install openssl-devel -y &&\
	yum install glut-devel -y &&\
	yum install qt5-qtx11extras-devel -y && \
	yum install qt5-qtsvg-devel -y && rm -rf /var/cache/yum
WORKDIR /root/
ARG cmakefile="https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4.tar.gz"
ADD ${cmakefile} ./
RUN tar xvfz cmake-3.16.4.tar.gz && rm cmake-3.16.4.tar.gz
WORKDIR /root/cmake-3.16.4
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make install
WORKDIR /


