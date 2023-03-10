FROM {{ service_base_image.image }}

RUN hail-pip-install pyspark==3.1.1
COPY hail/python/pinned-requirements.txt requirements.txt
COPY hail/python/dev/pinned-requirements.txt dev-requirements.txt
RUN hail-pip-install -r requirements.txt -r dev-requirements.txt

ENV SPARK_HOME /usr/local/lib/python3.7/dist-packages/pyspark
ENV PATH "$PATH:$SPARK_HOME/sbin:$SPARK_HOME/bin"
ENV PYSPARK_PYTHON python3

RUN curl -f >${SPARK_HOME}/jars/gcs-connector-hadoop2-2.2.7.jar https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-2.2.7.jar
COPY docker/core-site.xml ${SPARK_HOME}/conf/core-site.xml

RUN hail-apt-get-install liblz4-dev
