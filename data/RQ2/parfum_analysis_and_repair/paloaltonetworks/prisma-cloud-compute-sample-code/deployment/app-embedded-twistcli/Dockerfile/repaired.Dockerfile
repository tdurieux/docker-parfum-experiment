FROM tomcat:7

ARG struts2_version=2.3.12
ARG owner_email=tomcat@paloaltonetworks.com

RUN apt-get update && apt-get -y --no-install-recommends install curl git nmap dnsutils && rm -rf /var/lib/apt/lists/*;
RUN set -ex \
        && rm -rf /usr/local/tomcat/webapps/* \
        && chmod a+x /usr/local/tomcat/bin/*.sh
RUN curl -f -o /usr/local/tomcat/webapps/ROOT.war https://repo1.maven.org/maven2/org/apache/struts/struts2-showcase/${struts2_version}/struts2-showcase-${struts2_version}.war
EXPOSE 8080

ENTRYPOINT ["catalina.sh", "run"]


