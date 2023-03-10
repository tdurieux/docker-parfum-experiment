#
# Copyright (C) 2015 The Gravitee team (http://gravitee.io)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM alpine:3.9 AS build-env
MAINTAINER Gravitee Team <http://gravitee.io>

ARG GRAVITEEAPIM_VERSION=0

RUN apk add --no-cache --update zip unzip

RUN echo $GRAVITEEAPIM_VERSION

ADD ./gravitee-rest-api-standalone-${GRAVITEEAPIM_VERSION}.zip /tmp/
RUN unzip /tmp/gravitee-rest-api-standalone-${GRAVITEEAPIM_VERSION}.zip -d /tmp/

FROM adoptopenjdk/openjdk11:jre-11.0.10_9-alpine
MAINTAINER Gravitee Team <http://gravitee.io>

RUN apk add --no-cache --update curl

ENV GRAVITEEAPIM_HOME /opt/graviteeio-management-api

COPY --from=build-env /tmp/gravitee-rest-api-standalone-* ${GRAVITEEAPIM_HOME}/

RUN chgrp -R 0 ${GRAVITEEAPIM_HOME} && \
    chmod -R g=u ${GRAVITEEAPIM_HOME}

WORKDIR ${GRAVITEEAPIM_HOME}

EXPOSE 8083
VOLUME ${GRAVITEEAPIM_HOME}/logs
CMD ["./bin/gravitee"]
HEALTHCHECK --interval=5s --timeout=3s --retries=6 --start-period=30s \
            CMD curl --user admin:adminadmin --fail http://localhost:18083/_node/health || exit 1
