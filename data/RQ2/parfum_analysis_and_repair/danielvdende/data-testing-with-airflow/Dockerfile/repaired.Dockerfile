# VERSION 1.8.1-1
# AUTHOR: Matthieu "Puckel_" Roisil
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t puckel/docker-airflow .
# SOURCE: https://github.com/puckel/docker-airflow

FROM python:3.6

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Java
ARG JAVA_MAJOR_VERSION=8
ARG JAVA_MINOR_VERSION=231

# Spark
ARG SPARK_VERSION=2.4.4

# Airflow
ARG AIRFLOW_VERSION=1.9.0
ARG AIRFLOW_HOME=/usr/local/airflow
ENV AIRFLOW_HOME=/usr/local/airflow

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN set -ex \
    && buildDeps=' \
        python3-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        build-essential \
        libblas-dev \
        liblapack-dev \
        libpq-dev \
        git \
    ' \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        python3-pip \
        python3-requests \
        apt-utils \
        curl \
        netcat \
        locales \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && python -m pip install -U pip setuptools wheel \
    && pip install --no-cache-dir Cython \
    && pip install --no-cache-dir pytz \
    && pip install --no-cache-dir pyOpenSSL \
    && pip install --no-cache-dir ndg-httpsclient \
    && pip install --no-cache-dir pytest \
    && pip install --no-cache-dir pyasn1 \
    && pip install --no-cache-dir apache-airflow[crypto,celery,postgres,hive,jdbc]==$AIRFLOW_VERSION \
    && pip install --no-cache-dir celery[redis]==3.1.17 \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base
# Java

RUN cd /opt/ \
  && wget \
    --no-cookies \
    --no-check-certificate \
    --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
    "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=240718_5b13a193868b4bf28bcb45c792fce896"\
    -O jre-${JAVA_MAJOR_VERSION}.tar.gz \
  && tar xzf jre-${JAVA_MAJOR_VERSION}.tar.gz \
  && rm jre-${JAVA_MAJOR_VERSION}.tar.gz \
  && update-alternatives --install /usr/bin/java java /opt/jre1.${JAVA_MAJOR_VERSION}.0_${JAVA_MINOR_VERSION}/bin/java 100
# SPARK
RUN cd /usr/ \
  && wget "https://www-eu.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz" \
  && tar xzf spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
  && rm spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
  && mv spark-${SPARK_VERSION}-bin-hadoop2.7 spark

ENV SPARK_HOME /usr/spark
ENV SPARK_MAJOR_VERSION 2
ENV PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$SPARK_HOME/python/:$PYTHONPATH

RUN mkdir -p /usr/spark/work/ \
  && chmod -R 777 /usr/spark/work/

ENV SPARK_MASTER_PORT 7077

COPY docker_files/entrypoint.sh /entrypoint.sh
COPY docker_files/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN chown -R airflow: ${AIRFLOW_HOME}
RUN chown airflow: /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080 5555 8793

WORKDIR ${AIRFLOW_HOME}
# dev
RUN mkdir -p ${AIRFLOW_HOME}/dags
COPY docker_files/populate_tables.py /usr/local/airflow/populate_tables.py
RUN cd ${AIRFLOW_HOME}/dags && git clone https://github.com/danielvdende/data-testing-with-airflow.git development
RUN cd ${AIRFLOW_HOME}/dags/development && git checkout development
COPY docker_files/dev.conf ${AIRFLOW_HOME}/dags/development/dags/environment.conf
# tst
RUN cd ${AIRFLOW_HOME}/dags && git clone https://github.com/danielvdende/data-testing-with-airflow.git test
RUN cd ${AIRFLOW_HOME}/dags/test && git checkout test
COPY docker_files/tst.conf ${AIRFLOW_HOME}/dags/test/dags/environment.conf
#
## acc
RUN cd ${AIRFLOW_HOME}/dags && git clone https://github.com/danielvdende/data-testing-with-airflow.git acceptance
RUN cd ${AIRFLOW_HOME}/dags/acceptance && git checkout acceptance
COPY docker_files/acc.conf ${AIRFLOW_HOME}/dags/acceptance/dags/environment.conf
#
## prd
RUN cd ${AIRFLOW_HOME}/dags && git clone https://github.com/danielvdende/data-testing-with-airflow.git production
RUN cd ${AIRFLOW_HOME}/dags/production && git checkout master
COPY docker_files/prd.conf ${AIRFLOW_HOME}/dags/production/dags/environment.conf

ENTRYPOINT /entrypoint.sh
RUN cd /usr/local/airflow && /usr/spark/bin/spark-submit --master local populate_tables.py
