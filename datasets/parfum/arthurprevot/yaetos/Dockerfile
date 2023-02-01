FROM docker.io/bitnami/spark:2.4.5
# docker.io/bitnami/spark:2.4.5 -> spark 2.4.5, python 3.6.10, scala 2.11.12, https://github.com/bitnami/bitnami-docker-spark, https://hub.docker.com/r/bitnami/spark
# FROM bde2020/spark-master:2.4.5-hadoop2.7  # https://github.com/big-data-europe/docker-spark, https://hub.docker.com/r/bde2020/spark-master. Failed installing python libs below. Seems to be missing basic compilers.
# FROM jupyter/pyspark-notebook # spark 3.0.0. scala 2.12, Python 3.8.5. https://github.com/jupyter/docker-stacks, https://hub.docker.com/r/jupyter/pyspark-notebook. Was used successfully. Now leads to problems with sparks newly added jars that rely on scala 2.11.
# FROM jupyter/pyspark-notebook:2fd856878b83  # to try later to get setup when spark got to 2.4.5 (https://github.com/jupyter/docker-stacks/commit/45d51e3b42b83748fe64997b0e39473aeee10377)
# FROM arthurpr/pyspark_aws_etl:latest
# FROM arthurpr/pyspark_aws_etl:oracle # also available to skip oracle install steps below.
# TODO: build spark image from vanilla ubuntu (or other), see https://github.com/masroorhasan/docker-pyspark
USER root

# Pip installs. Using local copy to tmp dir to allow checkpointing this step (no re-installs as long as requirements.txt doesn't change)
COPY yaetos/scripts/requirements.txt /tmp/requirements.txt
WORKDIR /tmp/
RUN apt-get update && apt-get install -y git
RUN pip3 install -r requirements.txt
RUN apt install nodejs -y

WORKDIR /mnt/yaetos

ENV YAETOS_FRAMEWORK_HOME /mnt/yaetos/
ENV PYTHONPATH $YAETOS_FRAMEWORK_HOME:$PYTHONPATH
# ENV SPARK_HOME /usr/local/spark # already set in base docker image
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/build:$PYTHONPATH

ENV YAETOS_JOBS_HOME /mnt/yaetos_jobs/
ENV PYTHONPATH $YAETOS_JOBS_HOME:$PYTHONPATH

# Expose ports for monitoring.
# SparkContext web UI on 4040 -- only available for the duration of the application.
# Spark master’s web UI on 8080.
# Spark worker web UI on 8081.
# Jupyter web UI on 8888.
EXPOSE 4040 8080 8081 8888

# CMD ["/bin/bash"] # commented so the command can be sent by docker run

# Usage: docker run -it -p 4040:4040 -p 8080:8080 -p 8081:8081 -v ~/code/yaetos:/mnt/yaetos -v ~/.aws:/root/.aws -h spark <image_id>
# or update launch_env.sh and execute it.
