FROM java:latest

COPY pivotal-gemfire-9.3.0.tgz /tmp

VOLUME /data
WORKDIR /data

RUN tar xfz /tmp/pivotal-gemfire-9.3.0.tgz -C /opt; rm /tmp/pivotal-gemfire-9.3.0.tgz \
    ln -s /opt/pivotal-gemfire-9.3.0 /opt/gemfire