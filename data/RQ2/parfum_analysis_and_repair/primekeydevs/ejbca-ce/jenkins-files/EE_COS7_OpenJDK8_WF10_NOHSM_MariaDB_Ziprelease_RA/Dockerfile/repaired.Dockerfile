FROM jboss/wildfly:12.0.0.Final

USER root

#Create Ant Dir
RUN mkdir -p /opt/ant/

#Download Ant 1.9.8
ENV ANT_HOME /opt/ant/apache-ant-1.9.8
ENV ANT_SHA1 ca31bd42c27f7e63cccb219ee59930fdc943ca82

RUN cd $HOME \
    && curl -f -O http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.8-bin.tar.gz \
    && sha1sum apache-ant-1.9.8-bin.tar.gz | grep $ANT_SHA1 \
    && tar xf apache-ant-1.9.8-bin.tar.gz \
    && mv $HOME/apache-ant-1.9.8 $ANT_HOME \
    && rm apache-ant-1.9.8-bin.tar.gz \
    && chown -R jboss:0 ${ANT_HOME} \
    && chmod -R g+rw ${ANT_HOME}

#Updating Path
ENV PATH="${PATH}:${HOME}/bin:${ANT_HOME}/bin"

#Setting environment variables
ENV JAVA_OPTS="-Xms2048m -Xmx2048m -XX:MetaspaceSize=192M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true"

#Setting Ant Params
ENV ANT_OPTS="-Xms256M -Xmx512M"

RUN yum install -y which && rm -rf /var/cache/yum

# copy WildFly conf
ADD standalone.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml

# add mariadb driver to deploy folder
ADD mariadb-java-client.jar /opt/jboss/wildfly/standalone/deployments/mariadb-java-client.jar

# copy p12 folder to /opt in the container for runtime-usage
ADD p12 /opt/p12
RUN chmod 777 /opt/p12

# copy ejbca conf to /opt in the container for runtime-usage
ADD conf /opt/conf
RUN chmod 777 /opt/conf

# copy ManagementCA.pem to /opt in the container for runtime-usage
ADD ManagementCA.pem /opt/ManagementCA.pem
RUN chmod 777 /opt/ManagementCA.pem

ADD run.sh /opt/
RUN chmod +x /opt/run.sh

# Fix permissions (1001 is the jenkins user)
RUN chown -R 1001:1001 /opt/jboss/wildfly
USER 1001:1001

# Set the working directory to EJBCA rource root folder
WORKDIR /app/ejbca

CMD ["/opt/run.sh"]
