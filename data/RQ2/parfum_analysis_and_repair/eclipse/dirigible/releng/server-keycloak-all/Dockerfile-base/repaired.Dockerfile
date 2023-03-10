# Docker descriptor for Dirigible
# License - http://www.eclipse.org/legal/epl-v20.html

ARG DIRIGIBLE_VERSION=latest
FROM dirigiblelabs/dirigible-base-platform:$DIRIGIBLE_VERSION

RUN curl -f https://repo1.maven.org/maven2/org/keycloak/keycloak-tomcat8-adapter-dist/4.0.0.Beta3/keycloak-tomcat8-adapter-dist-4.0.0.Beta3.zip --create-dirs -o /usr/local/tomcat/lib/keycloak-tomcat8-adapter-dist.zip
RUN cd /usr/local/tomcat/lib && unzip keycloak-tomcat8-adapter-dist.zip
COPY src/main/webapp/META-INF/context.xml /usr/local/tomcat/webapps/ROOT/META-INF/
COPY src/main/webapp/WEB-INF/keycloak.json /usr/local/tomcat/webapps/ROOT/WEB-INF/
COPY src/main/webapp/WEB-INF/keycloak.json /usr/local/tomcat/webapps/ROOT/WEB-INF/

RUN wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.1.4/postgresql-42.1.4.jar -P /usr/local/tomcat/lib/

ENV DIRIGBLE_JAVASCRIPT_GRAALVM_DEBUGGER_PORT=0.0.0.0:8081