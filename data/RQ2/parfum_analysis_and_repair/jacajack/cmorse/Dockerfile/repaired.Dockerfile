FROM centos:7.2.1511

RUN yum -y install gcc \
                    make && rm -rf /var/cache/yum

RUN mkdir /opt/cmorse
COPY . /opt/cmorse
WORKDIR /opt/cmorse
RUN make all
RUN make install
