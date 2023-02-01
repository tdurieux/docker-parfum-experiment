###########################################################################
# (C) Copyright IBM Corporation 2015, 2016.                               #
#                                                                         #
# Licensed under the Apache License, Version 2.0 (the "License");         #
# you may not use this file except in compliance with the License.        #
# You may obtain a copy of the License at                                 #
#                                                                         #
#      http://www.apache.org/licenses/LICENSE-2.0                         #
#                                                                         #
# Unless required by applicable law or agreed to in writing, software     #
# distributed under the License is distributed on an "AS IS" BASIS,       #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
# See the License for the specific language governing permissions and     #
# limitations under the License.                                          #
###########################################################################

FROM ubuntu:16.04

MAINTAINER Kavitha Suresh Kumar <kavisuresh@in.ibm.com>

RUN apt-get update && apt-get install -y unzip wget

ARG user=was

ARG group=was

RUN groupadd $group && useradd $user -g $group -m\
    && chown -R $user:$group /var /opt /tmp

USER $user

ARG URL

###################### IBM Installation Manager ##########################

# Install IBM Installation Manager
RUN wget -q $URL/agent.installer.lnx.gtk.x86_64_1.8.5.zip -O /tmp/IM.zip \
    && mkdir /tmp/im && unzip -qd /tmp/im /tmp/IM.zip \
    && /tmp/im/installc -acceptLicense -accessRights nonAdmin \
      -installationDirectory "/opt/IBM/InstallationManager"  \
      -dataLocation "/var/ibm/InstallationManager" -showProgress \
    && rm -fr /tmp/IM.zip /tmp/im

### IBM WebSphere Application Server & IBM Java SDK ######################

# Install IBM WebSphere Application Server v9 & IBM Java SDK 8.0.3
RUN wget -q $URL/WAS_ND_V9.0_MP_ML.zip -O /tmp/was.zip \
    && wget -q $URL/sdk.repo.8030.java8.hpux.zip -O /tmp/java.zip \
    && mkdir /tmp/was /tmp/java && unzip -qd /tmp/was /tmp/was.zip \
    && unzip -qd /tmp/java /tmp/java.zip \
    && /opt/IBM/InstallationManager/eclipse/tools/imcl -showProgress \
      -acceptLicense install com.ibm.websphere.ND.v90 com.ibm.java.jdk.v8 \
      -repositories /tmp/was/repository.config,/tmp/java/repository.config \
      -installationDirectory /opt/IBM/WebSphere/AppServer \
      -preferences com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false \
    && rm -fr /tmp/was /tmp/java /tmp/was.zip /tmp/java.zip 

CMD ["tar","cvf","/tmp/was.tar","/opt/IBM/WebSphere/AppServer"]
