#       Copyright 2017 IBM Corp All Rights Reserved

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

ENV JAVA_VERSION_PREFIX 1.8.0
ENV HOME /home/default

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       amd64|x86_64) \
         YML_FILE='sdk/linux/x86_64/index.yml'; \
         ;; \
       i386) \
         YML_FILE='sdk/linux/i386/index.yml'; \
         ;; \
       ppc64el|ppc64le) \
         YML_FILE='sdk/linux/ppc64le/index.yml'; \
         ;; \
       s390) \
         YML_FILE='sdk/linux/s390/index.yml'; \
         ;; \
       s390x) \
         YML_FILE='sdk/linux/s390x/index.yml'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    BASE_URL="https://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/meta/"; \
    wget -q -U UA_IBM_JAVA_Docker -O /tmp/index.yml ${BASE_URL}/${YML_FILE}; \
    ESUM=$(cat /tmp/index.yml | sed -n '/'${JAVA_VERSION_PREFIX}'/{n;n;p}' | sed -n 's/\s*sha256sum:\s//p' | tr -d '\r' | tail -1); \
    JAVA_URL=$(cat /tmp/index.yml | sed -n '/'${JAVA_VERSION_PREFIX}'/{n;p}' | sed -n 's/\s*uri:\s//p' | tr -d '\r' | tail -1); \
    wget -q -U UA_IBM_JAVA_Docker -O /tmp/ibm-java.bin ${JAVA_URL}; \
    echo "${ESUM} /tmp/ibm-java.bin" | sha256sum -c -; \
    echo "INSTALLER_UI=silent" > /tmp/response.properties; \
    echo "USER_INSTALL_DIR=$HOME/java" >> /tmp/response.properties; \
    echo "LICENSE_ACCEPTED=TRUE" >> /tmp/response.properties; \
    mkdir -p $HOME/java; \
    chmod +x /tmp/ibm-java.bin; \
    /tmp/ibm-java.bin -i silent -f /tmp/response.properties; \
    rm -f /tmp/response.properties; \
    rm -f /tmp/index.yml; \
    rm -f /tmp/ibm-java.bin; \
    cd $HOME/java/jre/lib; \
    rm -rf icc;

RUN mkdir -p $HOME/mvn; \
    MAVEN_VERSION=$(wget -qO- https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/maven-metadata.xml | sed -n 's/\s*<release>\(.*\)<.*>/\1/p'); \
    wget -q -U UA_IBM_JAVA_Docker -O $HOME/mvn/apache-maven-${MAVEN_VERSION}-bin.tar.gz https://search.maven.org/remotecontent?filepath=org/apache/maven/apache-maven/${MAVEN_VERSION}/apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    tar xf $HOME/mvn/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C $HOME/mvn; \
    mv $HOME/mvn/apache-maven-${MAVEN_VERSION} $HOME/mvn/apache-maven; \
    rm -f $HOME/mvn/apache-maven-${MAVEN_VERSION}-bin.tar.gz;

RUN mkdir -m 777 -p /config/resources

ENV JAVA_HOME=$HOME/java \
    PATH=$HOME/java/jre/bin:$HOME/mvn/apache-maven/bin:$PATH
