# Use jbossdemocentral/developer as the base
FROM jbossdemocentral/developer:jdk8-uid

# Maintainer details
MAINTAINER Andrew Block <andy.block@gmail.com>

# Environment Variables
ENV BPMS_HOME /opt/jboss/bpms/jboss-eap-7.0
ENV BPMS_VERSION_MAJOR 6
ENV BPMS_VERSION_MINOR 4
ENV BPMS_VERSION_MICRO 0
ENV BPMS_VERSION_PATCH GA

ENV EAP_VERSION_MAJOR 7
ENV EAP_VERSION_MINOR 0
ENV EAP_VERSION_MICRO 0
#ENV EAP_VERSION_PATCH 7

ENV EAP_INSTALLER=jboss-eap-$EAP_VERSION_MAJOR.$EAP_VERSION_MINOR.$EAP_VERSION_MICRO-installer.jar
ENV BPMS_DEPLOYABLE=jboss-bpmsuite-$BPMS_VERSION_MAJOR.$BPMS_VERSION_MINOR.$BPMS_VERSION_MICRO.$BPMS_VERSION_PATCH-deployable-eap7.x.zip

# ADD Installation Files
COPY support/installation-eap support/installation-eap.variables installs/$BPMS_DEPLOYABLE installs/$EAP_INSTALLER /opt/jboss/

# Update Permissions on Installers
USER root
RUN chown 1000:1000 /opt/jboss/$EAP_INSTALLER /opt/jboss/$BPMS_DEPLOYABLE
USER 1000

# Prepare and run installer and cleanup installation components
RUN sed -i "s:<installpath>.*</installpath>:<installpath>$BPMS_HOME</installpath>:" /opt/jboss/installation-eap \
    && java -jar /opt/jboss/jboss-eap-$EAP_VERSION_MAJOR.$EAP_VERSION_MINOR.$EAP_VERSION_MICRO-installer.jar  /opt/jboss/installation-eap -variablefile /opt/jboss/installation-eap.variables \
    #&& $BPMS_HOME/bin/jboss-cli.sh --command="patch apply /opt/jboss/jboss-eap-$EAP_VERSION_MAJOR.$EAP_VERSION_MINOR.$EAP_VERSION_PATCH-patch.zip --override-all" \
    && unzip -qo /opt/jboss/$BPMS_DEPLOYABLE  -d $BPMS_HOME/.. \
    && rm -rf /opt/jboss/$BPMS_DEPLOYABLE /opt/jboss/$EAP_INSTALLER /opt/jboss/installation-eap /opt/jboss/installation-eap.variables $BPMS_HOME/standalone/configuration/standalone_xml_history/

# Copy demo and support files
COPY support/bpm-suite-demo-niogit $BPMS_HOME/bin/.niogit

#Create users and add support files
RUN $BPMS_HOME/bin/add-user.sh -a -r ApplicationRealm -u bpmsAdmin -p bpmsuite1! -ro analyst,admin,appraiser,broker,manager,kie-server,rest-all --silent \
  && $BPMS_HOME/bin/add-user.sh -a -r ApplicationRealm -u kieserver -p kieserver1! -ro kie-server --silent \
  && $BPMS_HOME/bin/add-user.sh -a -r ApplicationRealm -u erics -p bpmsuite1! -ro analyst,admin,appraiser,broker,manager,kie-server,rest-all --silent
COPY projects /opt/jboss/bpms-projects
COPY support/jboss-mortgage-demo-ws.war $BPMS_HOME/standalone/deployments/
COPY support/userinfo.properties $BPMS_HOME/standalone/deployments/business-central.war/WEB-INF/classes/
COPY support/jbpm.xml $BPMS_HOME/standalone/deployments/business-central.war/org.kie.workbench.KIEWebapp/profiles/
COPY support/standalone.xml $BPMS_HOME/standalone/configuration/
COPY support/jboss-mortgage-demo-client.jar /opt/jboss/support/

# Swtich back to root user to perform build and cleanup
USER root

# Adjust permissions and cleanup
RUN chown -R 1000:1000 /opt/jboss/support $BPMS_HOME/standalone/deployments/jboss-mortgage-demo-ws.war $BPMS_HOME/bin/.niogit $BPMS_HOME/standalone/configuration/standalone.xml $BPMS_HOME/standalone/deployments/business-central.war/WEB-INF/classes/userinfo.properties $BPMS_HOME/standalone/deployments/business-central.war/org.kie.workbench.KIEWebapp/profiles/ \
  && rm -rf /opt/jboss/bpms-projects

# Run as JBoss
USER 1000

# Expose Ports
EXPOSE 9990 9999 8080

# Run BPMS