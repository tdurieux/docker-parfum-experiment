FROM daggerok/jboss:eap-6.4
RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 \"" >> ${JBOSS_HOME}/bin/standalone.conf
EXPOSE 5005
ADD ./target/*.war ${JBOSS_HOME}/standalone/deployments/