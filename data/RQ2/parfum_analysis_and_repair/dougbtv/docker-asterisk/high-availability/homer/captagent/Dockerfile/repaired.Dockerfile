# Project @ https://github.com/sipcapture/captagent
# A capture agent for Homer sip capture server.

FROM centos:centos7
MAINTAINER Doug Smith <info@laboratoryb.org>
ENV build_date 2014-12-21

# Install deps.
RUN yum install -y libpcap automake expat-devel libtool git libpcap-devel file && rm -rf /var/cache/yum
RUN yum install -y make && rm -rf /var/cache/yum

ENV captagent_version 0x00001
RUN git clone https://github.com/sipcapture/captagent.git
WORKDIR /captagent/
RUN git reset --hard 2f12fbe63887b827bea831e2ab5739929ac4904a
WORKDIR /captagent/captagent

RUN ./build.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

WORKDIR /

COPY captagent.xml /usr/local/etc/captagent/captagent.xml
COPY run.sh /

EXPOSE 8909
ENTRYPOINT [ "/run.sh" ]