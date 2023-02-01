##
# Copyright (c) KMG. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
##

# Building Container
FROM gradle:6.0.1-jdk11 as GradleBuilder
USER root

COPY ca-certificates/* /usr/local/share/ca-certificates/
RUN update-ca-certificates

ENV APP_NAME=sbk
ENV SBK_DRIVER=driver-file
ENV APP_HOME=/opt/${APP_NAME}

WORKDIR /opt/sbk

COPY --chown=root:root gradle ${APP_HOME}/gradle
COPY --chown=root:root build.gradle ${APP_HOME}/build.gradle
COPY --chown=root:root gradle.properties ${APP_HOME}/gradle.properties
COPY --chown=root:root settings.gradle ${APP_HOME}/settings.gradle
COPY --chown=root:root gradlew ${APP_HOME}/gradlew
COPY --chown=root:root checkstyle ${APP_HOME}/checkstyle
COPY --chown=root:root sbk-api ${APP_HOME}/sbk-api

# Copy the SBK storage drivers
COPY --chown=root:root  ${SBK_DRIVER}   ${APP_HOME}/${SBK_DRIVER}

ENV GRADLE_USER_HOME=/opt/SBK
RUN gradle  :${SBK_DRIVER}:build --no-daemon --info --stacktrace

# Runtime Container
FROM openjdk:11-jre
ENV APP_NAME=sbk
ENV SBK_DRIVER=driver-file
ENV APP_HOME=/opt/${APP_NAME}

COPY --from=GradleBuilder ${APP_HOME}/${SBK_DRIVER}/build/distributions/${APP_NAME}-*.tar /opt/${APP_NAME}.tar

RUN tar -xvf /opt/${APP_NAME}.tar -C /opt/.
RUN mv /opt/${APP_NAME}-* /opt/${APP_NAME}

EXPOSE 9718

ENTRYPOINT ["/opt/sbk/bin/sbk-file"]
