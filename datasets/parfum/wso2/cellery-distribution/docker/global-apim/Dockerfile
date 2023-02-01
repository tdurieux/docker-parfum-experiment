# ------------------------------------------------------------------------
#
# Copyright 2018 WSO2, Inc. (http://wso2.com)
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
# limitations under the License
#
# ------------------------------------------------------------------------

FROM wso2cellery/wso2am-base:2.6.0

ARG USER_HOME=/home/wso2carbon
ARG FILES=./target/files

# Copy the jar files
COPY --chown=wso2carbon:wso2 ${FILES}/dropins/** ${USER_HOME}/wso2am-2.6.0/repository/components/dropins/
COPY --chown=wso2carbon:wso2 ${FILES}/lib/** ${USER_HOME}/wso2am-2.6.0/repository/components/lib/

# Copying the STS Web App
COPY --chown=wso2carbon:wso2 ${FILES}/webapps/** ${USER_HOME}/wso2am-2.6.0/repository/deployment/server/webapps/
COPY --chown=wso2carbon:wso2 ${FILES}/webapps/** ${USER_HOME}/wso2-tmp/server/webapps/

RUN mkdir ${USER_HOME}/wso2am-2.6.0/repository/deployment/server/webapps/authenticationendpoint

RUN cd ${USER_HOME}/wso2am-2.6.0/repository/deployment/server/webapps/authenticationendpoint ; \
jar -xvf ${USER_HOME}/wso2am-2.6.0/repository/deployment/server/webapps/authenticationendpoint.war

COPY --chown=wso2carbon:wso2 ${FILES}/authenticationendpoint/ ${USER_HOME}/wso2am-2.6.0/repository/deployment/server/webapps/authenticationendpoint/


RUN mkdir ${USER_HOME}/wso2-tmp/server/webapps/authenticationendpoint

RUN cd ${USER_HOME}/wso2-tmp/server/webapps/authenticationendpoint ; \
jar -xvf ${USER_HOME}/wso2-tmp/server/webapps/authenticationendpoint.war

COPY --chown=wso2carbon:wso2 ${FILES}/authenticationendpoint/ ${USER_HOME}/wso2-tmp/server/webapps/authenticationendpoint/
