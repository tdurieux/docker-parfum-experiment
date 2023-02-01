# Content: openjdk-8-jdk + spark + livy + databand[spark]

ARG DOCKER_IMAGE_BASE=python:3.6
FROM ${DOCKER_IMAGE_BASE}

# Java installation:
RUN apt-get update -y -qq && \
    apt-get install --no-install-recommends -y -qq software-properties-common apt-transport-https && \
    apt-add-repository --yes -m 'deb http://security.debian.org/debian-security stretch/updates main' && \
    apt-get update -y -qq && apt-get install --no-install-recommends -y -qq openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

# Spark installation:
ENV SPARK_VERSION=2.4.5
ENV HADOOP_VERSION=2.7
RUN wget --no-verbose https://dbnd-dev-playground.s3.amazonaws.com/packages/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

ENV PATH=$PATH:/spark/bin
ENV SPARK_HOME=/spark
ENV HADOOP_CONF_DIR=/etc/hadoop/conf

RUN pip install --no-cache-dir pyspark==${SPARK_VERSION} && \
    mv /spark/conf/spark-env.sh.template /spark/conf/spark-env.sh && \
    echo "export DBND_HOME=/app/" >> /spark/conf/spark-env.sh

# Livy installation:
ENV LIVY_VERSION=0.6.0
RUN wget --no-verbose https://dbnd-dev-playground.s3.amazonaws.com/packages/apache-livy-${LIVY_VERSION}-incubating-bin.zip && \
    unzip apache-livy-${LIVY_VERSION}-incubating-bin.zip && \
    mv apache-livy-${LIVY_VERSION}-incubating-bin /livy && \
    rm apache-livy-${LIVY_VERSION}-incubating-bin.zip && \
    echo "livy.file.local-dir-whitelist = /" >> /livy/conf/livy.conf
ENV PATH=$PATH:/livy/bin

# install dbnd packages:
COPY ./dbnd-core/dist-python/dbnd.requirements.txt \
    ./dbnd-core/dist-python/dbnd-spark.requirements.txt \
    ./dbnd-core/dist-python/dbnd-test-scenarios.requirements.txt \
    /dist-python/
RUN pip install --no-cache-dir -r /dist-python/dbnd.requirements.txt && \
    pip install --no-cache-dir -r /dist-python/dbnd-spark.requirements.txt && \
    pip install --no-cache-dir -r /dist-python/dbnd-test-scenarios.requirements.txt

COPY ./dbnd-core/dist-python/databand-*.whl \
    ./dbnd-core/dist-python/dbnd-*.whl \
    ./dbnd-core/dist-python/dbnd_spark-*.whl \
    ./dbnd-core/dist-python/dbnd_test_scenarios-*.whl \
    /dist-python/
RUN pip install --no-cache-dir databand[spark] dbnd_test_scenarios --find-links /dist-python/ --no-index

EXPOSE 8998

CMD livy-server start && sleep infinity
