FROM openjdk:8-jre-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y procps binutils vim curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY ./java-services/docker/startup.sh /startup.sh

COPY AppServerAgent/ /opt/appdynamics/

COPY ./cert/cacerts-none.jks /opt/appdynamics/ver4.5.11.26665/conf/cacerts.jks

RUN chmod +x /startup.sh

RUN chmod +w /etc/resolv.conf


ADD ./java-services/docker/java-services.jar java-services.jar

ENTRYPOINT ["/bin/bash", "/startup.sh"]
