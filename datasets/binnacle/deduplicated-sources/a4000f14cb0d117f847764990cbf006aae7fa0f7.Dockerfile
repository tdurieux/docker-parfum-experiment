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

FROM maximo/ibmim

MAINTAINER Yasutaka Nishimura <nishi2go@gmail.com>

ARG fp=1

ARG url=http://images
ARG httpport=80
ARG installfp=yes
ARG skin=iot18

ENV TEMP /tmp
WORKDIR /tmp

# Install required packages
RUN apt update && apt install -y netcat inetutils-ping && rm -rf /var/lib/apt/lists/*

## Install Maximo middleware and installer
RUN mkdir /Launchpad
WORKDIR /Launchpad

ENV BYPASS_PRS=True

## Install Maximo V7.6.1
ENV MAM_IMAGE MAM_7.6.1_LINUX64.tar.gz
## Remove z from tar command because file is not gzipped despite having gz extension
RUN wget -q $url/$MAM_IMAGE && tar xpf $MAM_IMAGE \
 && /opt/IBM/InstallationManager/eclipse/tools/imcl \
 -input /Launchpad/SilentResponseFiles/Unix/ResponseFile_MAM_Install_Unix.xml \
 -acceptLicense -log /tmp/MAM_Install_Unix.xml \
 && rm $MAM_IMAGE

RUN mkdir /work
WORKDIR /work

# Install Maximo V7.6.1 feature pack

ENV MAM_FP_IMAGE MAMMTFP761${fp}IMRepo.zip
RUN if [ "${installfp}" = "yes" ]; then wget -q $url/$MAM_FP_IMAGE && sleep 30 \
 && /opt/IBM/InstallationManager/eclipse/tools/imcl install \
 com.ibm.tivoli.tpae.base.tpae.main -repositories /work/$MAM_FP_IMAGE \
 -installationDirectory /opt/IBM/SMP -log /tmp/FP_Install_Unix.xml -acceptLicense \
 && /opt/IBM/InstallationManager/eclipse/tools/imcl install \
 com.ibm.tivoli.tpae.base.mam.main -repositories /work/$MAM_FP_IMAGE \
 -installationDirectory /opt/IBM/SMP -log /tmp/FP_Install_Unix.xml -acceptLicense \
 && rm $MAM_FP_IMAGE; fi

ENV MAXADMIN_PASSWORD maxadmin
ENV MAXREG_PASSWORD maxreg
ENV MXINTADM_PASSWORD mxintadm
ENV BASE_LANG en
ENV ADMIN_EMAIL_ADDRESS root@localhost
ENV SMTP_SERVER_HOST_NAME localhost
ENV MAXDB MAXDB76
ENV DB_HOST_NAME maxdb
ENV DB_PORT 50005
ENV DB_MAXIMO_PASSWORD maximo
ENV DMGR_ADMIN_USER wasadmin
ENV DMGR_ADMIN_PASSWORD wasadmin
ENV DMGR_HOST_NAME maxdmgr
ENV DMGR_PORT 8879
ENV WAS_DM_PROFILE_NAME ctgDmgr01
ENV WAS_DM_NODE_NAME ctgCellManager01
ENV WAS_NODE_NAME ctgNode01
ENV WEB_SERVER_NAME webserver1
ENV WEB_SERVER_HOST_NAME maxweb
ENV WEB_SERVER_PORT ${httpport}
ENV APP_SERVER_HOST_NAME maxapps
ENV APP_SERVER_PORT 8878
ENV UPDATE_APPS_ON_REBOOT yes

RUN wget -q https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    && mv wait-for-it.sh /usr/local/bin && chmod +x /usr/local/bin/wait-for-it.sh

RUN wget -q https://raw.githubusercontent.com/wsadminlib/wsadminlib/master/bin/wsadminlib.py

COPY StopAllServers.py /work
COPY StartAllServers.py /work
COPY AddVirtualHosts.py /work
COPY SetAutoRestart.py /work

ENV SKIN=${skin}

COPY startinstall.sh /work
RUN chmod +x /work/startinstall.sh
ENTRYPOINT ["/work/startinstall.sh"]
