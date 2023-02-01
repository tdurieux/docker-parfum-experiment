## Tomcat
#FROM tomcat:9-jdk11-openjdk
#ENV DEPLOY_DIR=/usr/local/tomcat/webapps

## WildFly
FROM jboss/wildfly
ENV DEPLOY_DIR=/opt/jboss/wildfly/standalone/deployments

## Glassfish
#FROM glassfish
#ENV DEPLOY_DIR=$GLASSFISH_HOME/glassfish/domains/domain1/autodeploy