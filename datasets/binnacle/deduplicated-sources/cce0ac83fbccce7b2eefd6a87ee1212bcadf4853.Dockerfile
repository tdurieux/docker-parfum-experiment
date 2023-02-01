############################################################################
# (C) Copyright IBM Corporation 2015, 2019                                 #
#                                                                          #
# Licensed under the Apache License, Version 2.0 (the "License");          #
# you may not use this file except in compliance with the License.         #
# You may obtain a copy of the License at                                  #
#                                                                          #
#      http://www.apache.org/licenses/LICENSE-2.0                          #
#                                                                          #
# Unless required by applicable law or agreed to in writing, software      #
# distributed under the License is distributed on an "AS IS" BASIS,        #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
# See the License for the specific language governing permissions and      #
# limitations under the License.                                           #
#                                                                          #
############################################################################

# Build step - download and install tWAS
FROM ubuntu:16.04 as builder
RUN apt-get update && apt-get install -y openssl wget unzip

ARG IMURL
ARG IBMID
ARG IBMID_PWD
ARG IFIXES=none
ARG PRODUCTID=com.ibm.websphere.ILAN.v90
ARG REPO=https://www.ibm.com/software/repositorymanager/V9WASILAN

RUN mkdir /work && cd /work && wget $IMURL \
  && unzip -q agent.installer.linux.gtk.x86_64*.zip -d /work/InstallationManagerKit \
  && rm -rf agent.installer.linux.gtk.x86_64*.zip \
  && echo "your_secureStore_password" > /tmp/secureStorePwd \
  && /work/InstallationManagerKit/tools/imutilsc saveCredential \
    -userName $IBMID -userPassword $IBMID_PWD \
    -secureStorageFile /tmp/secureStore \
    -masterPasswordFile /tmp/secureStorePwd \
    -url $REPO -verbose \
  && /work/InstallationManagerKit/tools/imcl install \
    $PRODUCTID com.ibm.java.jdk.v8 \
    -acceptLicense -accessRights nonAdmin -showProgress \
    -installationDirectory /opt/IBM/WebSphere/AppServer -repositories $REPO \
    -installFixes $IFIXES -sRD /opt/IBM/WebSphere/AppServerIMShared \
    -dataLocation /opt/IBM/WebSphere/AppServerIMData \
    -secureStorageFile /tmp/secureStore -masterPasswordFile /tmp/secureStorePwd \
    -preferences offering.service.repositories.areUsed=false,\
com.ibm.cic.common.core.preferences.searchForUpdates=true,\
com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false,\
com.ibm.cic.common.core.preferences.keepFetchedFiles=false \
  && rm -Rf /tmp/secureStorePwd /tmp/secureStore /work/InstallationManagerKit \
  && chmod -R g+rw /opt/IBM/

RUN sed -i 's/-Xms256m/-Xms1024m/g' /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh \
    && sed -i 's/-Xmx256m/-Xmx1024m/g' /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh


# Final image
FROM ubuntu:16.04
ARG BUILDLABEL=none

LABEL maintainer="Arthur De Magalhaes <arthurdm@ca.ibm.com>" \
      BuildLabel="$BUILDLABEL"

RUN apt-get update && apt-get install -y openssl wget unzip

ARG USER=was

ARG PROFILE_NAME=AppSrv01
ARG CELL_NAME=DefaultCell01
ARG NODE_NAME=DefaultNode01
ARG HOST_NAME=localhost
ARG SERVER_NAME=server1
ARG ADMIN_USER_NAME=wsadmin

COPY scripts/ /work/
COPY licenses /licenses/

RUN useradd $USER -g 0 -m --uid 1001 \
  && mkdir /opt/IBM \
  && chmod -R +x /work/* \
  && mkdir /etc/websphere \
  && mkdir /work/config \
  && chown -R 1001:0 /work /opt/IBM /etc/websphere \
  && chmod -R g+rwx /work

COPY --chown=1001:0 --from=builder /opt/IBM /opt/IBM
USER $USER

ENV PATH=/opt/IBM/WebSphere/AppServer/bin:$PATH \
    PROFILE_NAME=$PROFILE_NAME \
    SERVER_NAME=$SERVER_NAME \
    ADMIN_USER_NAME=$ADMIN_USER_NAME \
    EXTRACT_PORT_FROM_HOST_HEADER=true

RUN /work/create_profile.sh \
  && find /opt/IBM -user was ! -perm -g=w -print0 | xargs -0 chmod g+w \
  && chmod -R g+rwx /home/was/.java/

USER root
RUN ln -s /opt/IBM/WebSphere/AppServer/profiles/${PROFILE_NAME}/logs /logs && chown 1001:0 /logs
USER $USER

CMD ["/work/start_server.sh"]
