FROM ubuntu:18.04 AS base

ARG PYTHON_VERSION=3.6

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update && apt-get install --no-install-recommends -y \
    openjdk-8-jdk \
    wget bzip2 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

ENV PYTHON_VERSION $PYTHON_VERSION
ENV SCALA_VERSION 2.11.8
ENV SPARK_VERSION 3.1.1
ENV SPARK_BUILD "spark-${SPARK_VERSION}-bin-hadoop2.7"
ENV SPARK_BUILD_URL "https://downloads.apache.org/spark/spark-${SPARK_VERSION}/${SPARK_BUILD}.tgz"
RUN wget $SPARK_BUILD_URL -O /tmp/spark.tgz && \
    tar -C /opt -xf /tmp/spark.tgz && \
    mv /opt/$SPARK_BUILD /opt/spark && \
    rm /tmp/spark.tgz
ENV SPARK_HOME /opt/spark
ENV PATH $SPARK_HOME/bin:$PATH
ENV PYTHONPATH /opt/spark/python/lib/py4j-0.10.7-src.zip:/opt/spark/python/lib/pyspark.zip:$PYTHONPATH
ENV PYSPARK_PYTHON python3
ENV PYSPARK_DRIVER_PYTHON python3

WORKDIR /app

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN pip3 install --no-cache-dir tensorflow pandas numpy matplotlib seaborn scipy jupyter sparkflow

RUN apt install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;

COPY . /app

WORKDIR /notebooks

RUN jupyter notebook --generate-config

RUN echo "" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py