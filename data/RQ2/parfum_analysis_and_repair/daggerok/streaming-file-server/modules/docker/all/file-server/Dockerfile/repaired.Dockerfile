#FROM openjdk:8u191-jre-alpine3.8
##FROM openjdk:8u181-jre-alpine3.8
###FROM openjdk:8u151-jre-alpine3.7
#LABEL MAINTAINER='Maksim Kostromin https://github.com/daggerok'
#
#ARG APP_UPLOAD_PATH_ARG='/var/file-storage'
#ENV APP_UPLOAD_PATH="${APP_UPLOAD_PATH_ARG}"
#
#RUN apk add --no-cache --update bash sudo wget busybox-suid openssh-client  && \
#    adduser -h /home/appuser -s /bin/bash -D -u 1025 appuser wheel          && \
#    echo 'appuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers                  && \
#    sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers             && \
#    apk del --no-cache busybox-suid openssh-client                          && \
#    ( rm -rf /var/cache/apk/* /tmp/* || echo 'oops...' )                    && \
#    mkdir -p ${APP_UPLOAD_PATH}                                             && \
#    chown -cR appuser ${APP_UPLOAD_PATH}
#
#USER appuser
#WORKDIR /home/appuser
#VOLUME /home/appuser
#
#ARG JAVA_OPTS_ARGS="\
#-Djava.net.preferIPv4Stack=true \
#-XX:+UnlockExperimentalVMOptions \
#-XX:+UnlockExperimentalVMOptions \
#-XshowSettings:vm "
#ENV JAVA_OPTS="${JAVA_OPTS} ${JAVA_OPTS_ARGS}"
#
#ENTRYPOINT java ${JAVA_OPTS} -jar ./app.jar --spring.profiles.active=db-pg
#CMD /bin/ash