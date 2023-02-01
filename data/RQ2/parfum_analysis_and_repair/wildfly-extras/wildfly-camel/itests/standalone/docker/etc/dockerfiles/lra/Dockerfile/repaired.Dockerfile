FROM openjdk:8-jre-slim

ENV NARAYANA_VERSION=5.9.3.Final

RUN apt update && \
    apt install --no-install-recommends curl -y && \
    apt clean && \
    curl -f -L https://downloads.jboss.org/jbosstm/${NARAYANA_VERSION}/binary/narayana-full-${NARAYANA_VERSION}-bin.zip > /tmp/narayana.zip && \
    mkdir /opt/lra && \
    unzip /tmp/narayana.zip && \
    cp narayana-full-${NARAYANA_VERSION}/rts/lra/lra-coordinator-swarm.jar /opt/lra/ && \
    rm -rf narayana-full-${NARAYANA_VERSION} /tmp/narayana.zip && rm -rf /var/lib/apt/lists/*;

CMD [ "java", "-jar", "/opt/lra/lra-coordinator-swarm.jar", "-Djava.net.preferIPv4Stack=true", "-Dswarm.http.port=46000" ]
