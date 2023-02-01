FROM openjdk:8u151-jdk

LABEL maintainer="idpadmin@infosys.com"\
      owner="Infosys Ltd."

EXPOSE 8090/tcp

COPY target/idpsubscription.jar /idpsubscription/idpsubscription.jar
COPY idpsubscription.sh /idpsubscription/idpsubscription.sh
RUN chmod +x /idpsubscription/idpsubscription.sh

ENTRYPOINT /idpsubscription/idpsubscription.sh