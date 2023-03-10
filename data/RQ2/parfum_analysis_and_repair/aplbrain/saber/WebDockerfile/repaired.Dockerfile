#### Conduit airflow server ####

# Mainly copied from Puckel_ : https://github.com/puckel/docker-airflow

FROM python:3.6-slim

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.10.4
ARG AIRFLOW_HOME=/root

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV AIRFLOW_GPL_UNIDECODE True
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
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        python3-pip \
        python3-requests \
        default-libmysqlclient-dev \
        apt-utils \
        curl \
        rsync \
        netcat \
        locales \
        default-mysql-server \
        default-mysql-client \
    && apt-get install --no-install-recommends -y git \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && pip install --no-cache-dir -U pip setuptools wheel \
    && pip install --no-cache-dir werkzeug==0.16.0 \
    && pip install --no-cache-dir SQLAlchemy==1.3.15 \
    && pip install --no-cache-dir Cython \
    && pip install --no-cache-dir pytz \
    && pip install --no-cache-dir pyOpenSSL \
    && pip install --no-cache-dir ndg-httpsclient \
    && pip install --no-cache-dir pyasn1 \
    && pip install --no-cache-dir apache-airflow[crypto,celery,postgres,hive,jdbc,mysql]==$AIRFLOW_VERSION \
    && pip install --no-cache-dir celery[redis]==4.1.1 && rm -rf /var/lib/apt/lists/*;
    # && apt-get purge --auto-remove -yqq $buildDeps \
    # && apt-get autoremove -yqq --purge \
    # && apt-get clean \
    # && rm -rf \
    #     /var/lib/apt/lists/* \
    #     /tmp/* \
    #     /var/tmp/* \
    #     /usr/share/man \
    #     /usr/share/doc \
    #     /usr/share/doc-base

# RUN git clone https://github.com/aplbrain/cwl-airflow-parser.git \
#     && cd cwl-airflow-parser \
#     && pip install -U . \
#     && cd ../

COPY ./conduit/scripts/entrypoint.sh /entrypoint.sh
COPY ./conduit/config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN chown -R airflow: ${AIRFLOW_HOME}

EXPOSE 8080 5555 8793

# USER airflow
WORKDIR /home
ENTRYPOINT ["/entrypoint.sh"]
COPY ./conduit /conduit
COPY ./setup.py /
RUN pip install --no-cache-dir -e /
