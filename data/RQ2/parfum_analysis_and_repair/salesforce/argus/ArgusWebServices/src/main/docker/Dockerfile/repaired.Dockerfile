FROM tomcat:7.0.73-jre8

RUN apt-get -qq update -y && apt-get -qq --no-install-recommends install -y telnet net-tools less vim && rm -rf /var/lib/apt/lists/*;

ARG WAR
COPY ${WAR} /usr/local/tomcat/webapps/argus.war