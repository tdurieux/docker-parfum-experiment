#
# Copyright 2017 StreamSets Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM jeanblanchard/java:serverjre-8

MAINTAINER Adam Kunicki <adam@streamsets.com>
EXPOSE 18630

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update && apk add bash && apk add snappy

# Default user, overridable via -e option when executing docker run.
ENV SDC_USER=sdc
RUN addgroup -S ${SDC_USER} && adduser -S ${SDC_USER} ${SDC_USER}

ADD streamsets-datacollector-*$SDC_VERSION$*.tgz /opt/
ENV SDC_DIST /opt/streamsets-datacollector-$SDC_VERSION$

# Disable authentication by default, can be overriden with custom sdc.properties.
RUN sed -i 's|\(http.authentication=\).*|\1none|' ${SDC_DIST}/etc/sdc.properties && chown -R sdc:sdc ${SDC_DIST}

# Log to stdout for docker instead of sdc.log
RUN sed -i 's|DEBUG|INFO|' ${SDC_DIST}/etc/sdc-log4j.properties && sed -i 's|INFO, streamsets|INFO, stdout|' ${SDC_DIST}/etc/sdc-log4j.properties

ENV SDC_DATA=/data \
    SDC_LOG=/logs \
    SDC_CONF=/etc/sdc

RUN mkdir -p ${SDC_DATA} /mnt ${SDC_LOG} && mv ${SDC_DIST}/etc ${SDC_CONF} && chown ${SDC_USER}:${SDC_USER} ${SDC_DATA} ${SDC_LOG}
# Can be used to mount volumes from other containers or the host
VOLUME /mnt
# Volume for storing collector state. Do not share this between collectors.
VOLUME ${SDC_DATA}
# Volume containing configuration of the data collector
VOLUME ${SDC_CONF}

USER ${SDC_USER}

ENTRYPOINT ["/opt/streamsets-datacollector-$SDC_VERSION$/bin/streamsets"]
CMD ["dc"]
