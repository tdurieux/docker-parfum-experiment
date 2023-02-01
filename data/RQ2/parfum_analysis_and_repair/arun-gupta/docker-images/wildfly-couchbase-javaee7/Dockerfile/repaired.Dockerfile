FROM jboss/wildfly:latest

RUN sudo yum install -y jq && rm -rf /var/cache/yum

COPY check-for-bucket.sh /opt/jboss/wildfly/check-for-bucket.sh

RUN /opt/jboss/wildfly/check-for-bucket.sh

COPY couchbase-javaee.war /opt/jboss/wildfly/standalone/deployments/airlines.war

