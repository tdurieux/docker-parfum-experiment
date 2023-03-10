FROM cd/jenkins-slave-base

LABEL maintainer="Gerard Castillo <gerard.castillo@boehringer-ingelheim.com>"

ARG AIRFLOW_VERSION=1.10.2
ARG PYTHON_DEPS=""
ARG AIRFLOW_DEPS=""

ENV AIRFLOW_HOME=$HOME/airflow
ENV AIRFLOW_GPL_UNIDECODE yes
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

ENV PATH=$HOME/node_modules/.bin:/opt/rh/rh-nodejs8/root/usr/bin:/opt/rh/rh-python36/root/usr/bin${PATH:+:${PATH}} \
    LD_LIBRARY_PATH=/opt/rh/rh-nodejs8/root/usr/lib64:/opt/rh/rh-python36/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    MANPATH=/opt/rh/rh-nodejs8/root/usr/share/man:/opt/rh/rh-python36/root/usr/share/man:$MANPATH \
    PKG_CONFIG_PATH=/opt/rh/rh-python36/root/usr/lib64/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}} \
    XDG_DATA_DIRS="/opt/rh/rh-python36/root/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable
COPY contrib/npmrc $HOME/.npmrc

# Enable rhel-server-rhscl-7-rpms repo
RUN set -x && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --disable rhel-7-server-htb-rpms && \
    yum makecache

# Python 3.6 and NodeJS 8
RUN yum -y install @development && \
    yum -y install rh-nodejs8 && \
    yum -y install rh-python36 && \
    yum -y install rh-python36-numpy \
                    rh-python36-scipy \
                    rh-python36-python-tools \
                    rh-python36-python-six && rm -rf /var/cache/yum

# Configuring npm
RUN sed -i "s|NEXUS_HOST|$NEXUS_HOST|g" $HOME/.npmrc && \
    sed -i "s|NEXUS_AUTH|$(echo -n $NEXUS_AUTH | base64)|g" $HOME/.npmrc && \
    npm config set ca=null && \
    npm config set strict-ssl=false

# Upgrade pip and npm
RUN pip install --no-cache-dir --upgrade pip && \
    pip -V && \
    pip install --no-cache-dir virtualenv pycodestyle

# Configure pip SSL validation
RUN pip config set global.cert /etc/ssl/certs/ca-bundle.crt && \
    pip config list

# Airflow
RUN buildDeps=' \
        freetds-devel \
        krb5-devel \
        cyrus-sasl-devel \
        openssl-devel \
        libffi-devel \
        postgresql-devel \
        mariadb-devel \
        git \
    ' \
    && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install --assumeyes \
        $buildDeps \
        freetds \
        mariadb-libs \
        curl \
        rsync \
        nmap-ncat \
    && localedef -c -f UTF-8 -i en_US en_US.UTF-8 \
    && pip install --no-cache-dir -U pip setuptools wheel \
    && pip install --no-cache-dir pytz \
    && pip install --no-cache-dir pyOpenSSL \
    && pip install --no-cache-dir ndg-httpsclient \
    && pip install --no-cache-dir unittest-xml-reporting \
    && pip install --no-cache-dir pyasn1 \
    && pip install --no-cache-dir apache-airflow[crypto,rabbitmq,celery,postgres,hive,jdbc,mysql,ssh,kubernetes,elasticsearch${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}]==${AIRFLOW_VERSION} \
    && pip install --no-cache-dir 'redis>=3.2.0,<4' \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME
