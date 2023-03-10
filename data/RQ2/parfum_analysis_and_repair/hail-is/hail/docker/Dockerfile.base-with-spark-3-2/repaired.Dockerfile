FROM {{ base_image.image }}

RUN hail-pip-install pyspark==3.2.1
ENV SPARK_HOME /usr/local/lib/python3.7/dist-packages/pyspark
ENV PATH "$PATH:$SPARK_HOME/sbin:$SPARK_HOME/bin"
ENV PYSPARK_PYTHON python3

RUN curl -f >${SPARK_HOME}/jars/gcs-connector-hadoop2-2.2.7.jar https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-2.2.7.jar
COPY docker/core-site.xml ${SPARK_HOME}/conf/core-site.xml
