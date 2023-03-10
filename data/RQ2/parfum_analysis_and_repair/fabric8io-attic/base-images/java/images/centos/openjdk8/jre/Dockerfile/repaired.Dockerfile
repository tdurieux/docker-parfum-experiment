FROM centos:7

USER root

RUN mkdir /app
ENV JAVA_APP_DIR /app

RUN yum install -y \
       java-1.8.0-openjdk && rm -rf /var/cache/yum
ENV JAVA_HOME /etc/alternatives/jre

# Agent bond including Jolokia and jmx_exporter
ADD agent-bond-opts /opt/run-java-options
RUN mkdir -p /opt/agent-bond \
 && curl -f https://central.maven.org/maven2/io/fabric8/agent-bond-agent/0.1.3/agent-bond-agent-0.1.3.jar \
          -o /opt/agent-bond/agent-bond.jar \
 && chmod 444 /opt/agent-bond/agent-bond.jar \
 && chmod 755 /opt/run-java-options
ADD jmx_exporter_config.yml /opt/agent-bond/
EXPOSE 8778 9779

# Add run script as /app/run-java.sh and make it executable
COPY run-java.sh /app/run-java.sh
RUN chmod 755 /app/run-java.sh



CMD [ "/app/run-java.sh" ]
