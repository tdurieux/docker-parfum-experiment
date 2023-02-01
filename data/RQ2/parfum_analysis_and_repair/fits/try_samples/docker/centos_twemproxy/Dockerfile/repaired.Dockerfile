FROM centos

RUN yum -y update
RUN yum -y install make automake libtool git && rm -rf /var/cache/yum

RUN git clone https://github.com/twitter/twemproxy.git
RUN cd twemproxy && autoreconf -fvi && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
RUN rm -fr twemproxy

RUN yum clean all
