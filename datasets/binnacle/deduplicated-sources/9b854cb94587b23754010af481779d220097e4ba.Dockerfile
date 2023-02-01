FROM ubuntu:18.04

ENV LANG C.UTF-8

RUN apt-get update && \
  apt-get -y install \
    git \
    htop \
    unzip bzip2 zip tar \
    wget curl \
    rsync \
    emacs25-nox \
    mysql-client \
    xsltproc pandoc \
    jq \
    openjdk-8-jdk-headless \
    python \
    python3 python3-pip && \
  rm -rf /var/lib/apt/lists/*

# source: https://cloud.google.com/storage/docs/gsutil_install#linux
RUN /bin/sh -c 'curl https://sdk.cloud.google.com | bash' && \
    mv /root/google-cloud-sdk / && \
    /google-cloud-sdk/bin/gcloud -q components install beta kubectl
ENV PATH $PATH:/google-cloud-sdk/bin

RUN wget -nv -O spark-2.4.0-bin-hadoop2.7.tgz https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz && \
  tar xzf spark-2.4.0-bin-hadoop2.7.tgz && \
  rm spark-2.4.0-bin-hadoop2.7.tgz

RUN wget -nv -O /spark-2.4.0-bin-hadoop2.7/jars/gcs-connector-hadoop2-latest.jar https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-latest.jar
COPY core-site.xml /spark-2.4.0-bin-hadoop2.7/conf/core-site.xml

ENV SPARK_HOME /spark-2.4.0-bin-hadoop2.7
ENV PATH "$PATH:$SPARK_HOME/sbin:$SPARK_HOME/bin"

COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir -U -r requirements.txt

ENV PYTHONPATH "${PYTHONPATH:+${PYTHONPATH}:}$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip"
ENV PYSPARK_PYTHON python3
