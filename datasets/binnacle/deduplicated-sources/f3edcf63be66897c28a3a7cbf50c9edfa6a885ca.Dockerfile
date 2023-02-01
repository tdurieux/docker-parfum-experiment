FROM openjdk:8u151-jdk

LABEL maintainer="idpadmin@infosys.com"\
      owner="Infosys Ltd."

EXPOSE 8888/tcp

COPY target/idpconfig.jar /idpconfig/idpconfig.jar
COPY idpconfig.sh /idpconfig/idpconfig.sh
RUN chmod +x /idpconfig/idpconfig.sh

ENTRYPOINT /idpconfig/idpconfig.sh