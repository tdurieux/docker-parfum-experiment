FROM {{ hail_ubuntu_image.image }}

RUN hail-apt-get-install \
    htop \
    curl \
    rsync \
    openjdk-8-jdk-headless \
    liblapack3

COPY docker/linux-pinned-requirements.txt requirements.txt
RUN hail-pip-install -r requirements.txt pyspark==3.1.1

ENV SPARK_HOME /usr/local/lib/python3.7/dist-packages/pyspark
ENV PYSPARK_PYTHON python3

RUN curl -f https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-2.2.7.jar \
         > ${SPARK_HOME}/jars/gcs-connector-hadoop2-2.2.7.jar
COPY docker/core-site.xml ${SPARK_HOME}/conf/core-site.xml

COPY docker/service-base-requirements.txt .
RUN hail-pip-install -r service-base-requirements.txt

COPY hail/python/setup-hailtop.py /hailtop/setup.py
COPY hail/python/hailtop /hailtop/hailtop/
COPY /hail_version /hailtop/hailtop/hail_version
COPY hail/python/MANIFEST.in /hailtop/MANIFEST.in
RUN hail-pip-install /hailtop && rm -rf /hailtop

COPY gear/setup.py /gear/setup.py
COPY gear/gear /gear/gear/
RUN hail-pip-install /gear && rm -rf /gear

COPY web_common/setup.py web_common/MANIFEST.in /web_common/
COPY web_common/web_common /web_common/web_common/
RUN hail-pip-install /web_common && rm -rf /web_common
