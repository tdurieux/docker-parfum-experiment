# Using Azul Zulu patched JDK 11 (local built and published docker image)

# colljos@ci-agent-101l:~$ jdk11azul
#  openjdk version "11.0.3" 2019-04-16 LTS
#  OpenJDK Runtime Environment Zulu11.31+16-SA (build 11.0.3+7-LTS)
#  OpenJDK 64-Bit Server VM Zulu11.31+16-SA (build 11.0.3+7-LTS, mixed mode)

# Remember to set the DOCKER env variables accordingly to access the R3 Azure docker registry:
# export DOCKER_URL=https://corda.azurecr.io
# export DOCKER_USERNAME=<username>
# export DOCKER_PASSWORD=<password>

FROM corda.azurecr.io/jdk/azul/zulu-sa-jdk:11.0.3_7_LTS

## Add packages, clean cache, create dirs, create corda user and change ownership
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install bash curl unzip && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/corda/cordapps && \
    mkdir -p /opt/corda/persistence && \
    mkdir -p /opt/corda/artemis && \
    mkdir -p /opt/corda/certificates && \
    mkdir -p /opt/corda/drivers && \
    mkdir -p /opt/corda/logs && \
    mkdir -p /opt/corda/bin && \
    mkdir -p /opt/corda/additional-node-infos && \
    mkdir -p /etc/corda && \
    chown -R corda /opt/corda && \
    chgrp -R corda /opt/corda && \
    chown -R corda /etc/corda && \
    chgrp -R corda /etc/corda && \
    chown -R corda /opt/corda && \
    chgrp -R corda /opt/corda && \
    chown -R corda /etc/corda && \
    chgrp -R corda /etc/corda

ENV CORDAPPS_FOLDER="/opt/corda/cordapps" \
    PERSISTENCE_FOLDER="/opt/corda/persistence" \
    ARTEMIS_FOLDER="/opt/corda/artemis" \
    CERTIFICATES_FOLDER="/opt/corda/certificates" \
    DRIVERS_FOLDER="/opt/corda/drivers" \
    CONFIG_FOLDER="/etc/corda" \
    MY_P2P_PORT=10200 \
    MY_RPC_PORT=10201 \
    MY_RPC_ADMIN_PORT=10202 \
    PATH=$PATH:/opt/corda/bin \
    JVM_ARGS="-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions " \
    CORDA_ARGS=""

##CORDAPPS FOLDER
VOLUME ["/opt/corda/cordapps"]
##PERSISTENCE FOLDER
VOLUME ["/opt/corda/persistence"]
##ARTEMIS FOLDER
VOLUME ["/opt/corda/artemis"]
##CERTS FOLDER
VOLUME ["/opt/corda/certificates"]
##OPTIONAL JDBC DRIVERS FOLDER
VOLUME ["/opt/corda/drivers"]
##LOG FOLDER
VOLUME ["/opt/corda/logs"]
##ADDITIONAL NODE INFOS FOLDER
VOLUME ["/opt/corda/additional-node-infos"]
##CONFIG LOCATION
VOLUME ["/etc/corda"]

##CORDA JAR
COPY --chown=corda:corda corda.jar /opt/corda/bin/corda.jar
##CONFIG MANIPULATOR JAR
COPY --chown=corda:corda config-exporter.jar /opt/corda/config-exporter.jar
##CONFIG GENERATOR SHELL SCRIPT
COPY --chown=corda:corda generate-config.sh /opt/corda/bin/config-generator
##CORDA RUN SCRIPT
COPY --chown=corda:corda run-corda.sh /opt/corda/bin/run-corda
##BASE CONFIG FOR GENERATOR
COPY --chown=corda:corda starting-node.conf /opt/corda/starting-node.conf

USER "corda"
EXPOSE ${MY_P2P_PORT} ${MY_RPC_PORT} ${MY_RPC_ADMIN_PORT}
WORKDIR /opt/corda
CMD ["run-corda"]