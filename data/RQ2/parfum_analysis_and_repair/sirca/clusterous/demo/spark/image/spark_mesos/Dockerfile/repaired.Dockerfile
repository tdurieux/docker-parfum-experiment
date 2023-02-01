FROM ubuntu:14.04

MAINTAINER Lolo Fernandez <lolo.fernandez@sirca.org.au>

# == COMMON PACKAGES
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y wget curl bzip2 ca-certificates && rm -rf /var/lib/apt/lists/*;

# == SPARK
ENV SPARK_PACKAGE spark-1.4.0-bin-hadoop2.4
ENV SPARK_HOME /opt/$SPARK_PACKAGE
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.8.2.1-src.zip
ENV PATH $PATH:$SPARK_HOME/bin
RUN curl -f -sL --retry 3 \
  "https://d3kbcqa49mib13.cloudfront.net/$SPARK_PACKAGE.tgz" \
  | gunzip \
  | tar x -C /opt/ \
  && ln -s $SPARK_HOME /opt/spark

# == MESOS
RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
  apt-get -y update && \
  apt-get -y --no-install-recommends install mesos=0.22.1-1.0.ubuntu1404 && \
  apt-get clean && rm -rf /var/lib/apt/lists/*
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

# == PYTHON JUPYTER
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y python2.7-dev python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir jupyter wikipedia

# == BDKD DATASTORE
ADD datastore /tmp/datastore
RUN pip install --no-cache-dir /tmp/datastore/bdkd-datastore-0.1.8.zip; \
  pip install --no-cache-dir /tmp/datastore/datastorewrapper-0.1.8.zip; \
  rm -fr /tmp/datastore

# == Required by mesos master to launch spark docker containers
WORKDIR /opt
