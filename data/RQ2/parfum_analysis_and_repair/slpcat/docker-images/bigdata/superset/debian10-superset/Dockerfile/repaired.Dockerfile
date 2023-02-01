FROM amancevice/superset
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

USER root

RUN \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq apt-utils dialog vim-tiny curl locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales && rm -rf /var/lib/apt/lists/*;

# Install required packages
RUN \
    apt-get dist-upgrade -y

COPY pip.conf /etc/pip.conf
#Database dependencies
RUN \
    pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir psycopg2-binary \
    && pip install --no-cache-dir "PyAthenaJDBC>1.0.9" \
    && pip install --no-cache-dir "PyAthena>1.2.0" \
    && pip install --no-cache-dir sqlalchemy-redshift \
    #&& pip install sqlalchemy-drill \
    && pip install --no-cache-dir pydruid \
    && pip install --no-cache-dir pyhive \
    && pip install --no-cache-dir impyla \
    && pip install --no-cache-dir kylinpy \
    && pip install --no-cache-dir pinotdb \
    && pip install --no-cache-dir pyhive \
    && pip install --no-cache-dir pybigquery \
    ##&& pip install sqlalchemy-clickhouse \
    && pip install --no-cache-dir clickhouse-sqlalchemy \
    && pip install --no-cache-dir elasticsearch-dbapi \
    #&& pip install sqlalchemy-exasol \
    && pip install --no-cache-dir gsheetsdb \
    && pip install --no-cache-dir ibm_db_sa \
    && pip install --no-cache-dir mysqlclient \
    && pip install --no-cache-dir cx_Oracle \
    && pip install --no-cache-dir psycopg2 \
    && pip install --no-cache-dir snowflake-sqlalchemy \
    && pip install --no-cache-dir pymssql \
    && pip install --no-cache-dir sqlalchemy-teradata \
    && pip install --no-cache-dir sqlalchemy-vertica-python \
    && pip install --no-cache-dir hdbcli sqlalchemy-hana


USER superset
