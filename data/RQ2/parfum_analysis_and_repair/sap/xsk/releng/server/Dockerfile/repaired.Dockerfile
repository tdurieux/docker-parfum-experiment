# Docker descriptor for Dirigible
# License - http://www.eclipse.org/legal/epl-v10.html

# (Optional) JDK_TYPE could be `default-jdk` or `external-jdk`
ARG JDK_TYPE=default-jdk

FROM  dirigiblelabs/xsk-kyma-runtime-base as base

COPY target/ROOT.war /usr/local/tomcat/webapps/

RUN wget --no-check-certificate https://www.dirigible.io/help/conf/tomcat-users.xml -P /usr/local/tomcat/conf/

FROM base AS xsk-external-jdk
# If JDK_TYPE is set to `external-jdk`, then the JDK_HOME is required and it should point to the home directory of the jdk