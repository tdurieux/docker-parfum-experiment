FROM uhopper/hadoop:2.7.2
LABEL maintainer="edxops"

RUN echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/backports.list

RUN \
echo "deb http://mirrors.linode.com/debian/ stretch main" > /etc/apt/sources.list && \
echo "deb-src http://mirrors.linode.com/debian/ stretch main" >> /etc/apt/sources.list && \
echo "deb http://mirrors.linode.com/debian-security/ stretch/updates main" >> /etc/apt/sources.list && \
echo "deb-src http://mirrors.linode.com/debian-security/ stretch/updates main" >> /etc/apt/sources.list && \
echo "deb http://mirrors.linode.com/debian/ stretch-updates main" >> /etc/apt/sources.list && \
echo "deb-src http://mirrors.linode.com/debian/ stretch-updates main" >> /etc/apt/sources.list

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name \
    MYSQL_VERSION=5.6 \
    DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp
RUN apt-get -y update
RUN apt-get -yqq --no-install-recommends install apt-transport-https lsb-release ca-certificates gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN ( apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5 \
    || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5 \
    || apt-key adv --keyserver hkps://hkps.pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5 )
RUN echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-${MYSQL_VERSION}" > /etc/apt/sources.list.d/mysql.list
RUN apt-get -y update \
    && apt-get install --no-install-recommends -y mysql-community-client \
    && apt-get install -y --no-install-recommends python python-setuptools \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name
ADD docker/build/analytics_pipeline_hadoop_namenode/namenode.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
