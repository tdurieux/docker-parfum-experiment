FROM openjdk:8-jdk

RUN apt update && apt install --no-install-recommends -y net-tools sudo git python && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y autoremove

RUN mkdir /opt/jmx_prometheus

RUN wget https://central.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.7/jmx_prometheus_javaagent-0.7.jar

RUN mv jmx_prometheus_javaagent-0.7.jar /opt/jmx_prometheus/jmx_prometheus_javaagent.jar

RUN echo "export JAVA_HOME=$JAVA_HOME" >> /etc/environment

