FROM tomcat:7-jre8

RUN apt-get update && apt-get install --no-install-recommends -y gettext-base && rm -rf /var/lib/apt/lists/*;

COPY target/Chimera.war /Chimera/
COPY config.properties.tpl /Chimera/
COPY src/main/resources/META-INF/persistence.xml.tpl /Chimera/
COPY docker_deploy.sh /Chimera/

CMD /Chimera/docker_deploy.sh
