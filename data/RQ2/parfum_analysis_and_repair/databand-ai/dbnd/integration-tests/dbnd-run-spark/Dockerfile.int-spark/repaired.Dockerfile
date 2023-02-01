# Content: openjdk-8-jdk + maven +

ARG DOCKER_IMAGE_BASE=python:3.6
FROM ${DOCKER_IMAGE_BASE}

# Java install
RUN apt-get update -y -qq && \
    apt-get install --no-install-recommends -y -qq software-properties-common apt-transport-https netcat && \
    apt-add-repository --yes -m 'deb http://security.debian.org/debian-security stretch/updates main' && \
    apt-get update -y -qq && apt-get install --no-install-recommends -y -qq openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
# EO Java install

# Maven install
ENV MAVEN_VERSION=3.6.3
RUN wget --no-verbose https://dbnd-dev-playground.s3.amazonaws.com/packages/apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN tar -zxf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/ && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz
ENV M2_HOME=/opt/apache-maven-${MAVEN_VERSION}
ENV M2=$M2_HOME/bin
ENV PATH=$M2:$PATH

ADD dbnd-core/examples/src/dbnd_examples/dbnd_spark/spark_jvm /app/spark_jvm
RUN (cd /app/spark_jvm && mvn install -q)
# EO Maven install

RUN apt-get update -y -qq && apt-get install --no-install-recommends -y -qq netcat && rm -rf /var/lib/apt/lists/*;

# instrumentation:
# install pip==21.3.1 for python 3.6
RUN pip install --no-cache-dir -U pytest sh pyspark tox pip==21.3.1 'setuptools<58'

# Pre-install Airflow with correct deps
ARG AIRFLOW_VERSION=1.10.10
RUN SHORT_PYTHON_VERSION=$(echo ${PYTHON_VERSION} | cut -f1,2 -d'.') && \
    pip install --no-cache-dir apache-airflow[postgres,mysql]==$AIRFLOW_VERSION \
        --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${SHORT_PYTHON_VERSION}.txt"

# install dbnd packages:
COPY ./dbnd-core/dist-python/dbnd.requirements.txt \
    ./dbnd-core/dist-python/dbnd-spark.requirements.txt \
    ./dbnd-core/dist-python/dbnd-test-scenarios.requirements.txt \
    ./dbnd-core/dist-python/dbnd-airflow.requirements.txt \
    ./dbnd-core/dist-python/dbnd-airflow[[]tests].requirements.txt \
    /dbnd-core/dist-python/examples.requirements.txt \
    /dist-python/
RUN pip install --no-cache-dir -r /dist-python/dbnd.requirements.txt && \
    pip install --no-cache-dir -r /dist-python/dbnd-spark.requirements.txt && \
    pip install --no-cache-dir -r /dist-python/dbnd-test-scenarios.requirements.txt && \
    pip install --no-cache-dir -r /dist-python/dbnd-airflow.requirements.txt && \
    pip install --no-cache-dir -r /dist-python/dbnd-airflow[tests].requirements.txt && \
    pip install --no-cache-dir -r /dist-python/examples.requirements.txt
COPY ./dbnd-core/dist-python/databand-*.whl \
    ./dbnd-core/dist-python/dbnd-*.whl \
    ./dbnd-core/dist-python/dbnd_spark-*.whl \
    ./dbnd-core/dist-python/dbnd_examples-*.whl \
    ./dbnd-core/dist-python/dbnd_test_scenarios-*.whl \
    ./dbnd-core/dist-python/dbnd_airflow-*.whl \
    /dist-python/
RUN pip install --no-cache-dir dbnd_airflow dbnd_examples databand[spark] dbnd_test_scenarios --find-links /dist-python/ --no-index

ENV DBND_EXAMPLES_PATH=/app/examples
WORKDIR /app/
