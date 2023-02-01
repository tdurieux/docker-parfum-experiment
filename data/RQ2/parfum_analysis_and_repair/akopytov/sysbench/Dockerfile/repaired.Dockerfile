FROM ubuntu:xenial

RUN apt-get update

RUN apt-get -y --no-install-recommends install make automake libtool pkg-config libaio-dev git && rm -rf /var/lib/apt/lists/*;

# For MySQL support
RUN apt-get -y --no-install-recommends install libmysqlclient-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

# For PostgreSQL support
RUN apt-get -y --no-install-recommends install libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/akopytov/sysbench.git sysbench

WORKDIR sysbench
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-mysql --with-pgsql
RUN make -j
RUN make install

WORKDIR /root
RUN rm -rf sysbench

ENTRYPOINT sysbench
