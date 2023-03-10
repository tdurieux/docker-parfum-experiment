FROM velvia/spark-jobserver:0.6.0

# Install mesos support per: https://github.com/mesosphere/docker-containers/blob/master/mesos/dockerfile-templates/mesos
ENV MESOS_VERSION 0.23.0-1.0.ubuntu1404
RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install mesos=${MESOS_VERSION} && rm -rf /var/lib/apt/lists/*;

RUN rm -Rf /spark

ENV SPARK_VERSION 1.5.1-bin-hadoop2.4

RUN apt-get install --no-install-recommends -y curl && \
    curl -sf "https://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}.tgz" | tar zx -C /opt && \
    mv "/opt/spark-${SPARK_VERSION}" /spark && rm -rf /var/lib/apt/lists/*;

ENV SPARK_HOME /spark
