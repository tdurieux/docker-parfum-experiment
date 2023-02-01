# Copyright 2021 Huawei Technologies Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from edgegallery/edget-tester:latest

ADD ./tc $OPEN_CLI_HOME

MAINTAINER TestGroup
LABEL version="0.9" description="api-integration-testing"

USER root

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get install --no-install-recommends -y sudo \
    && apt-get install --no-install-recommends --assume-yes apt-utils python3-pip python-pip -y \
    && apt-get install --no-install-recommends wget -y \
    && apt-get install --no-install-recommends git -y \
    && apt-get install --no-install-recommends rsync -y \
    && apt-get install --no-install-recommends -yqq unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
    && pip install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir robotframework \
    && pip3 install --no-cache-dir robotframework-sshlibrary \
    && pip3 install --no-cache-dir robotframework-seleniumlibrary \
    && pip3 install --no-cache-dir robotframework-requests \
    && pip3 install --no-cache-dir robotframework-jsonschemalibrary \
    && pip3 install --no-cache-dir RESTinstance \
    && pip3 install --no-cache-dir robotframework-jsonlibrary \
    && pip3 install --no-cache-dir selenium \
    && pip3 install --no-cache-dir robotframework==3.0.4

RUN apt-get -y update \
    && apt-get update && apt-get install --no-install-recommends -y gnupg2 \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && sudo apt-get -y update \
    && apt-get install --no-install-recommends -y google-chrome-stable \
    && wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/87.0.4280.20/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ \
    && chmod 777 /usr/local/bin/chromedriver \
    && apt-get remove google-chrome-stable -y \
    && apt-get install --no-install-recommends libsqlite3-dev chromium-driver -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/api/
ENV DISPLAY=:99
ENV PATH=$PATH:/home/api/
ENV PYTHONPATH /home/api/
COPY / /home/api/
WORKDIR /home/api/

ENV PLANPATH planpath
ENV PLATFORM platform
ENV SYSDEV sysdev
ENV SYSAPP sysapp
ENV SYSMECM sysmecm
ENV SCHEMA schema
ENV HOST rhost
ENV PORT Port
ENV HOSTIP H_Ip
ENV APMPORT apmPORT
ENV ESRPORT esrPORT
ENV APPOPORT appoPORT
ENV LCMPORT lcmPORT
ENV RIGHTHOSTIP righthip
ENV XSDKDATE xsdkdate
ENV SIGNATURE signature
ENV LOGINNAME loginname
ENV LOGINPASS loginpass
ENV LOGINPHONE loginphone
ENV APPNAME packagename
ENV INDUSTRY industry
ENV TYPE apptype
ENV AFFINITY affinity
ENV YAMLFile yFile
ENV SERVICENAME servicename
ENV OPEN_CLI_PRODUCT EdgeGallery
ENV GITEE_USER user
ENV GITEE_PASS pass
ENV AUTHOR 'edgeT team'

RUN rm -rf /tmp/it; git clone https://$GITEE_USER:$GITEE_PASS@gitee.com/edgegallery/integration-testing.git /tmp/it; \
mv /tmp/it/api-csit-master/* /home/api/ ;rm -rf /tmp/it; \
git clone "https://gerrit.onap.org/r/cli" -b robot-profile /tmp/del/; \
mv /tmp/del/profiles/robot/src/main/resources/script/* $OPEN_CLI_HOME/script/; rm -rf /tmp/del/; \
python3 /opt/ocomp/script/discover-robot-testcases.py  --api-tests-folder-path /home/api/tests/integration/EGCases/ \
--data_list_file_path /home/api/tests/resource/dataList.py --data_list_file_path1 /home/api/tests/resource/dataList1.py;

RUN pip3 install --no-cache-dir robotframework-extendedrequestslibrary \
&& pip3 install --no-cache-dir robotframework-selenium2library \
&& pip3 install --no-cache-dir RESTinstance

RUN bash /opt/ocomp/script/prepare.sh

RUN chmod +x /home/api/run-csit.sh

EXPOSE 8087
