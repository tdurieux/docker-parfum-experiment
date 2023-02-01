FROM centos:7

# image to build & test clickhouse odbc on centos7 & docker
# install all needed build & test dependancies

# docker build -f Dockerfile.centos7 . -t clickhouse-odbc-tester-centos7
# docker run --rm -it clickhouse-odbc-tester-centos7 bash

RUN yum install -y centos-release-scl  epel-release \
    && yum install -y devtoolset-7 cmake3 git ninja-build libtool-ltdl-devel unixODBC-devel perl-Test-Base perl-DBD-ODBC python-pip python-devel --nogpgcheck \
    && source scl_source enable devtoolset-7 \
    && pip install --no-cache-dir pyodbc && rm -rf /var/cache/yum

# altinity rpm
RUN curl -f -s https://packagecloud.io/install/repositories/altinity/clickhouse/script.rpm.sh | bash \
    && yum install -y clickhouse-server clickhouse-client && rm -rf /var/cache/yum

RUN git clone --recursive https://github.com/ClickHouse/clickhouse-odbc.git

RUN mkdir -p clickhouse-odbc/build \
    && cd clickhouse-odbc/build \
    && source scl_source enable devtoolset-7 \
    && cmake3 -G Ninja -DTEST_DSN_LIST="clickhouse_localhost;clickhouse_localhost_w" .. \
    && ninja-build

RUN ln -s /clickhouse-odbc/build/driver/libclickhouseodbc.so /usr/local/lib/libclickhouseodbc.so \
    && ln -s /clickhouse-odbc/build/driver/libclickhouseodbcw.so /usr/local/lib/libclickhouseodbcw.so \
    && echo '' >> ~/.odbc.ini \
    && echo '[clickhouse_localhost]' >> ~/.odbc.ini \
    && echo 'Driver=/usr/local/lib/libclickhouseodbc.so' >> ~/.odbc.ini \
    && echo 'url=http://localhost' >> ~/.odbc.ini \
    && echo '' >> ~/.odbc.ini \
    && echo '[clickhouse_localhost_w]' >> ~/.odbc.ini \
    && echo 'Driver=/usr/local/lib/libclickhouseodbcw.so' >> ~/.odbc.ini \
    && echo 'url=http://localhost' >> ~/.odbc.ini

# bit dirty way to start clickhouse via init.d scripts
RUN /etc/init.d/clickhouse-server start \
    && cd clickhouse-odbc/build \
    && ctest3 -V

ENTRYPOINT /etc/init.d/clickhouse-server start && sh $@

CMD bash