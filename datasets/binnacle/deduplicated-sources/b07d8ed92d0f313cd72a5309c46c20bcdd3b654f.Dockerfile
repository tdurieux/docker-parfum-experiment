FROM ubuntu:14.04

# Install packages
RUN apt-get update -y && apt-get install -y --no-install-recommends \
      curl \
      libblas3 \
      libgfortran3 \
      liblapack3 \
      openjdk-7-jre-headless \
    && rm -rf /var/lib/apt/lists/*

ENV SPARK_VERSION 1.5.1
ENV HADOOP_VERSION 2.6
ENV SPARK_STRING spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV SPARK_HOME /opt/${SPARK_STRING}

# Install Spark
RUN MIRROR=$(curl -s http://www.apache.org/dyn/closer.lua?as_json=1 | grep preferred | awk '{print $2}' | sed -e 's/"//g') \
    && SPARK_PATH=spark/spark-${SPARK_VERSION}/${SPARK_STRING}.tgz \
    && curl ${MIRROR}${SPARK_PATH} | tar -xzC /opt

