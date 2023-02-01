# VERSION 1.0
# AUTHOR: Jason Kuruzovich ("jkuruzovich")
# DESCRIPTION: Airflow container
# SOURCE: 
# VERSION 1.7.1.3-7
# AUTHOR: Matthieu "Puckel_" Roisil
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t puckel/docker-airflow .
# SOURCE: https://github.com/puckel/docker-airflow

FROM jupyter/pyspark-notebook
MAINTAINER jkuruzovich

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.7.1.3
ENV AIRFLOW_HOME /usr/local/airflow

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL  en_US.UTF-8
USER root
RUN set -ex \
    && buildDeps=' \
        python-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        build-essential \
        libblas-dev \
        liblapack-dev \
        libpq-dev \
    ' \
    && echo "deb http://http.debian.net/debian jessie-backports main" >/etc/apt/sources.list.d/backports.list \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        python-pip \
        apt-utils \
        curl \
        netcat \
        locales \
    && apt-get install -yqq -t jessie-backports python-requests \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && python -m pip install -U pip \
    && conda install --quiet --yes   Cython \
    && conda install --quiet --yes   pytz==2015.7 \
    && conda install --quiet --yes  pyOpenSSL \
    && conda install --quiet --yes pyasn1 \
    && conda install --quiet --yes pymongo \
    && conda install --quiet --yes boto3 \
    && conda install --quiet --yes psycopg2 \
    && conda install --quiet --yes httplib2 \
    && conda install --quiet --yes oauth2client \
    && conda install --quiet --yes requests \
    && pip install airflow[crypto,celery,postgres,hive,hdfs,jdbc]==$AIRFLOW_VERSION \
    && pip install celery[redis]==3.1.17 \
    && pip install  ndg-httpsclient \
    && apt-get remove --purge -yqq $buildDeps \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY script/entrypoint.sh /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
RUN chown -R airflow: ${AIRFLOW_HOME}
EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]