FROM ubuntu:16.04

MAINTAINER Aniket Panse <contact@aniketpanse.in>

RUN apt-get clean && \
    apt-get upgrade -y && \
    apt-get update -y --fix-missing && \
    apt-get install --no-install-recommends -y libmysqlclient-dev python-pip vim less git; rm -rf /var/lib/apt/lists/*;

ENV MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y mysql-server; rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir supervisor && echo_supervisord_conf;

RUN mkdir /opt/hornet;
COPY . /opt/hornet
WORKDIR /opt/hornet
RUN pip install --no-cache-dir . && pip install --no-cache-dir --upgrade git+https://github.com/ianepperson/telnetsrvlib.git#egg=telnetsrv-0.4.1;

ENTRYPOINT ["scripts/run.sh"]
