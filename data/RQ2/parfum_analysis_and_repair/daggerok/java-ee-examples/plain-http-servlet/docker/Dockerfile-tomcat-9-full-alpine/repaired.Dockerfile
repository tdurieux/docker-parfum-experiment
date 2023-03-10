# BASE_URL                                      R  VERSION                  VERSION
# https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.zip (java 7)
# https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.2/bin/apache-tomcat-9.0.2.zip   (java 8)

# git clone https://github.com/daggerok/apache-tomcat
# docker build -t daggerok/apache-tomcat -f apache-tomcat/Dockerfile .
# docker tag daggerok/apache-tomcat daggerok/apache-tomcat:9.0.2-alpine
# docker tag daggerok/apache-tomcat daggerok/apache-tomcat:9.0.2
# docker tag daggerok/apache-tomcat daggerok/apache-tomcat-alpine
# docker tag daggerok/apache-tomcat daggerok/apache-tomcat:latest
# docker push daggerok/apache-tomcat

FROM openjdk:8u151-jdk-alpine
MAINTAINER Maksim Kostromin https://github.com/daggerok/docker

ARG TOMCAT_RELEASE=9
ARG TOMCAT_VERSION=9.0.2
ARG TOMCAT_USER_ARG="tomcat"
ARG TOMCAT_FILE_ARG="apache-tomcat-${TOMCAT_VERSION}"
ARG TOMCAT_URL_ARG="https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_RELEASE}/v${TOMCAT_VERSION}/bin/${TOMCAT_FILE_ARG}.zip"

ENV JAVA_VERSION="8"
ENV TOMCAT_USER=${TOMCAT_USER_ARG} \
    TOMCAT_GROUP=${TOMCAT_USER_ARG}-group \
    TOMCAT_FILE=${TOMCAT_FILE_ARG} \
    TOMCAT_URL=${TOMCAT_URL_ARG}
ENV TOMCAT_USER_HOME="/home/${TOMCAT_USER}"
ENV TOMCAT_HOME="${TOMCAT_USER_HOME}/${TOMCAT_FILE}"

RUN apk --no-cache --update add busybox-suid bash wget ca-certificates unzip sudo openssh-client shadow \
 && addgroup ${TOMCAT_GROUP} \
 && echo "${TOMCAT_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && sed -i "s/.*requiretty$/Defaults !requiretty/" /etc/sudoers \
 && adduser -h ${TOMCAT_USER_HOME} -s /bin/bash -D -u 1025 ${TOMCAT_USER} ${TOMCAT_GROUP} \
 && usermod -a -G wheel ${TOMCAT_USER} \
 && apk del busybox-suid shadow \
 && rm -rf /var/cache/apk/* /tmp/*

USER ${TOMCAT_USER}
WORKDIR ${TOMCAT_USER_HOME}

CMD /bin/bash
EXPOSE 8080
ENTRYPOINT /bin/bash ${TOMCAT_HOME}/bin/catalina.sh start \
        && mkdir -p ${TOMCAT_HOME}/logs && touch ${TOMCAT_HOME}/logs/catalina.out \
        && chown -R ${TOMCAT_USER}:${TOMCAT_GROUP} ${TOMCAT_HOME}/logs \
        && tail -f ${TOMCAT_HOME}/logs/catalina.out

RUN wget ${TOMCAT_URL} -O "${TOMCAT_USER_HOME}/${TOMCAT_FILE}.zip" \
 && unzip "${TOMCAT_USER_HOME}/${TOMCAT_FILE}.zip" -d ${TOMCAT_USER_HOME} \
 && rm -rf "${TOMCAT_USER_HOME}/${TOMCAT_FILE}.zip"

##### USAGE BEGIN #####
#
# # apply base image:
# FROM daggerok/apache-tomcat:9.0.2-alpine
#
# # healthy check:
# HEALTHCHECK --interval=1s --timeout=3s --retries=30 \
# CMD wget -q --spider http://127.0.0.1:8080/health/ \
#  || exit 1
#
# # debug:
# ARG JPDA_OPTS_ARG="${JAVA_OPTS} -agentlib:jdwp=transport=dt_socket,address=1043,server=y,suspend=n"
# ENV JPDA_OPTS="${JPDA_OPTS_ARG}"
# EXPOSE 5005
#
# # deploy apps:
# COPY ./path/to/*.war ./path/to/another/*.war ${TOMCAT_HOME}/webapps/
#
##### USAGE END #####