ARG MTA_CLI_VERSION=5.2.2-SNAPSHOT
ARG DIVA_ADDON_VERSION=diva-0.1.3.1

FROM maven:3.8.4-openjdk-11 as build

WORKDIR /root

ARG MTA_CLI_VERSION
ARG DIVA_ADDON_VERSION
ENV MTA_CLI_BUILD_PATH=/root/mta-cli-${MTA_CLI_VERSION}

RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone -b ${DIVA_ADDON_VERSION} https://github.com/akihikot/windup.git
RUN mvn -f windup clean install -DskipTests

RUN git clone https://github.com/windup/windup-rulesets.git
RUN mvn -f windup-rulesets clean install -DskipTests

RUN git clone https://github.com/windup/windup-distribution.git
RUN mvn -f windup-distribution clean install -DskipTests

RUN jar xvf windup-distribution/target/mta-cli-${MTA_CLI_VERSION}-offline.zip

RUN curl -f -k -L -o janusgraph-0.3.2-hadoop2.zip https://github.com/JanusGraph/janusgraph/releases/download/v0.3.2/janusgraph-0.3.2-hadoop2.zip
RUN jar xvf janusgraph-0.3.2-hadoop2.zip

RUN chmod a+x ${MTA_CLI_BUILD_PATH}/bin/mta-cli
RUN ${MTA_CLI_BUILD_PATH}/bin/mta-cli --batchMode --install org.jboss.windup.rules.apps:windup-rules-java-diva:${MTA_CLI_VERSION}

FROM openjdk:11-jre

ENV UID=185

RUN useradd -m -u ${UID} diva
USER ${UID}

ENV HOME=/home/diva

WORKDIR ${HOME}

COPY windup/TitanConfiguration.properties ./
COPY windup/start-windup.sh ./

ARG MTA_CLI_VERSION
ENV MTA_CLI_BUILD_PATH=/root/mta-cli-${MTA_CLI_VERSION}

ENV JANUSGRAPH_PATH=${HOME}/janusgraph-0.3.2-hadoop2
ENV TCD_APPLICATION_PATH=${HOME}/app
ENV MTA_CLI_PATH=${HOME}/mta-cli

COPY --from=build /root/.mta ${HOME}/.mta
COPY --from=build ${MTA_CLI_BUILD_PATH} ${MTA_CLI_PATH}
COPY --from=build /root/janusgraph-0.3.2-hadoop2 janusgraph-0.3.2-hadoop2

USER root

RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN chown -R ${UID} ${HOME}

USER ${UID}

RUN sed -i janusgraph-0.3.2-hadoop2/conf/gremlin-server/gremlin-server.yaml -e 's/conf\/gremlin-server\/janusgraph-cql-es-server\.properties/\/home\/diva\/TitanConfiguration\.properties/g'
RUN sed -i janusgraph-0.3.2-hadoop2/conf/gremlin-server/gremlin-server.yaml -e 's/scripts\/empty-sample\.groovy/\/home\/diva\/janusgraph-0\.3\.2-hadoop2\/scripts\/empty-sample\.groovy/g'

RUN chmod a+x ${HOME}/start-windup.sh
RUN chmod a+x ${JANUSGRAPH_PATH}/bin/*.sh

ENTRYPOINT ["./start-windup.sh"]
