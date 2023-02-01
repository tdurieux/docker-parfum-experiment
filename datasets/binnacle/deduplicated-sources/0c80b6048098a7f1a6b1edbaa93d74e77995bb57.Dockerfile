FROM ubuntu:16.04 AS base

ARG PYTHON_VERSION=3.6

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    wget bzip2 \
    python3-pip

ENV PYTHON_VERSION $PYTHON_VERSION
ENV SCALA_VERSION 2.11.8
ENV SPARK_VERSION 2.4.0
ENV SPARK_BUILD "spark-${SPARK_VERSION}-bin-hadoop2.7"
ENV SPARK_BUILD_URL "https://dist.apache.org/repos/dist/release/spark/spark-2.4.0/${SPARK_BUILD}.tgz"
RUN wget $SPARK_BUILD_URL -O /tmp/spark.tgz && \
    tar -C /opt -xf /tmp/spark.tgz && \
    mv /opt/$SPARK_BUILD /opt/spark && \
    rm /tmp/spark.tgz
ENV SPARK_HOME /opt/spark
ENV PATH $SPARK_HOME/bin:$PATH
ENV PYTHONPATH /opt/spark/python/lib/py4j-0.10.7-src.zip:/opt/spark/python/lib/pyspark.zip:$PYTHONPATH
ENV PYSPARK_PYTHON python

WORKDIR /app

COPY . /app

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN pip3 install tensorflow pandas numpy matplotlib seaborn scipy jupyter pyspark sparkflow

RUN apt install -y supervisor

ENV PYSPARK_PYTHON python3
ENV PYSPARK_DRIVER_PYTHON python3
