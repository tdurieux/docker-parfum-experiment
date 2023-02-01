FROM ubuntu:14.04
MAINTAINER Andrei Ismail <iandrei@gmail.com>

LABEL vendor=proxysql\
      com.proxysql.type=proxysql\
      com.proxysql.os=ubuntu14\
      com.proxysql.interactive=false\
      com.proxysql.config=simple\
      com.proxysql.purpose=testing

RUN apt-get update && apt-get install --no-install-recommends -y \
	automake \
	cmake \
	make \
	g++ \
	gcc \
	gdb \
	gdbserver \
	git \
	libmysqlclient-dev \
	libssl-dev \
	libtool \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;

RUN cd /opt; git clone https://github.com/akopytov/sysbench.git
RUN cd /opt/sysbench; ./autogen.sh; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --bindir=/usr/bin; make; make install

ADD ./proxysql.cnf /etc/
RUN mkdir -p /var/lib/proxysql
ADD ./compile_and_start_proxysql.sh /tmp/
RUN chmod +x /tmp/compile_and_start_proxysql.sh

CMD ["/tmp/compile_and_start_proxysql.sh"]
