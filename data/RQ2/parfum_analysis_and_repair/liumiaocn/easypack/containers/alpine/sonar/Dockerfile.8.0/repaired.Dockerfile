###############################################################################
#
#IMAGE:   Sonarqube(JRE-SLIM)
#VERSION: 8.0
#
###############################################################################
FROM openjdk:11-jre-slim

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

###############################################################################
#ENV
###############################################################################
ENV SONAR_VERSION=8.0 \
    SOFTWARE=SONARQUBE \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

###############################################################################
#PORT
###############################################################################
# Http port
EXPOSE 9000

###############################################################################
#DOWNLOAD & PREPARE
###############################################################################
RUN set -x \
    && apt-get update && apt-get install --no-install-recommends -y curl gnupg2 unzip \
    && for server in $(shuf -e ha.pool.sks-keyservers.net hkp://p80.pool.sks-keyservers.net:80 \
                            keyserver.ubuntu.com hkp://keyserver.ubuntu.com:80 pgp.mit.edu) ; do \
        gpg --batch --keyserver "$server" --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE && break || : ; \
        done \
    && groupadd -r sonarqube && useradd -r -g sonarqube sonarqube \
    && gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
    && mkdir -p /opt \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && chown -R sonarqube:sonarqube sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/* \
    && rm -rf /var/lib/apt/lists/*

###############################################################################
#VOLUME
###############################################################################
VOLUME "$SONARQUBE_HOME/data"

###############################################################################
#SETTING
###############################################################################
WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/run.sh

USER sonarqube
ENTRYPOINT ["./bin/run.sh"]
