# --------------------------------------------------------------------
# Copyright (c) 2020, WSO2 Inc. (http://wso2.com) All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# -----------------------------------------------------------------------
FROM envoyproxy/envoy-alpine:v1.20.2
LABEL maintainer="WSO2 Docker Maintainers <wso2.com>"

RUN apk update && apk upgrade --no-cache

ENV LANG=C.UTF-8

ARG MG_USER=wso2
ARG MG_USER_ID=10500
ARG MG_USER_GROUP=wso2
ARG MG_USER_GROUP_ID=10500
ARG MG_USER_HOME=/home/${MG_USER}

ARG MOTD="\n\
 Welcome to WSO2 Docker Resources \n\
 --------------------------------- \n\
 This Docker container comprises of a WSO2 product, running with its latest GA release \n\
 which is under the Apache License, Version 2.0. \n\
 Read more about Apache License, Version 2.0 here @ http://www.apache.org/licenses/LICENSE-2.0.\n"

RUN \
    addgroup -S -g ${MG_USER_GROUP_ID} ${MG_USER_GROUP} \
    && adduser -S -u ${MG_USER_ID} -h ${MG_USER_HOME} -G ${MG_USER_GROUP} ${MG_USER} \
    && echo '[ ! -z "${TERM}" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc; echo "${MOTD}" > /etc/motd

ENV ROUTER_ADMIN_HOST=0.0.0.0
ENV ROUTER_ADMIN_PORT=9000

ENV ROUTER_CLUSTER=default_cluster
ENV ROUTER_LABEL="Default"
ENV ROUTER_PRIVATE_KEY_PATH=/home/wso2/security/keystore/mg.key
ENV ROUTER_PUBLIC_CERT_PATH=/home/wso2/security/keystore/mg.pem

ENV ADAPTER_HOST=adapter
ENV ADAPTER_PORT=18000
ENV ADAPTER_CA_CERT_PATH=/home/wso2/security/truststore/mg.pem

ENV ENFORCER_HOST=enforcer
ENV ENFORCER_PORT=8081
ENV ENFORCER_ANALYTICS_RECEIVER_PORT=18090
# Enforcer Analytics host