# Spark
FROM spark-base:1.0.0
MAINTAINER amplab amp-docker@eecs.berkeley.edu

# Instead of using a random port, bind the worker to a specific port
ENV SPARK_WORKER_PORT 8888
EXPOSE 8888

ADD files /root/spark_shell_files

# Add the entrypoint script for the master