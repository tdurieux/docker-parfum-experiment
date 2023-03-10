FROM openjdk:8u171-jre-alpine

ENV HAWKBIT_SIM_VERSION=0.3.0-SNAPSHOT \
    HAWKBIT_SIM_HOME=/opt/hawkbit-simulator

# Http port
EXPOSE 8083

RUN set -x \
    && mkdir -p $HAWKBIT_SIM_HOME \
    && cd $HAWKBIT_SIM_HOME \
    && apk add --no-cache libressl wget \
    && wget -O hawkbit-simluator.jar --no-verbose "https://repo.eclipse.org/service/local/artifact/maven/redirect?r=hawkbit-snapshots&g=org.eclipse.hawkbit&a=hawkbit-device-simulator&v=${HAWKBIT_SIM_VERSION}"

WORKDIR $HAWKBIT_SIM_HOME
ENTRYPOINT ["java","-jar","hawkbit-simluator.jar"]