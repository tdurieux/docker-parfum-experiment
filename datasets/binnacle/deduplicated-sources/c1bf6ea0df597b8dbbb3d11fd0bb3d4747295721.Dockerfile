FROM ubuntu:16.04

MAINTAINER Amir Barkal <amirb@webtech-inv.co.il>

RUN apt-get update && apt-get install -y unzip wget

ARG user=was

ARG group=was

RUN groupadd $group && useradd $user -g $group -m\
    && chown -R $user:$group /var /opt /tmp

USER $user

ARG URL

###################### IBM Installation Manager ##########################

# Install IBM Installation Manager
RUN wget -q $URL/Install_Mgr_v1.6.2_Lnx_WASv8.5.5.zip -O /tmp/IM.zip \
    && mkdir /tmp/im && unzip -qd /tmp/im /tmp/IM.zip \
    && /tmp/im/installc -acceptLicense -accessRights nonAdmin \
      -installationDirectory "/opt/IBM/InstallationManager"  \
      -dataLocation "/var/ibm/InstallationManager" -showProgress \
    && rm -fr /tmp/IM.zip /tmp/im

################# IBM WebSphere Application Server ######################

# Install IBM WebSphere Application Server ND v855
RUN wget -q $URL/WASND_v8.5.5_1of3.zip -O /tmp/was1.zip \
    && wget -q $URL/WASND_v8.5.5_2of3.zip -O /tmp/was2.zip \
    && wget -q $URL/WASND_v8.5.5_3of3.zip -O /tmp/was3.zip \
    && mkdir /tmp/was  && unzip  -qd /tmp/was /tmp/was1.zip \
    && unzip -qd /tmp/was /tmp/was2.zip \
    && unzip -qd /tmp/was /tmp/was3.zip \
    && /opt/IBM/InstallationManager/eclipse/tools/imcl -showProgress \
      -acceptLicense  install com.ibm.websphere.ND.v85 \
      -repositories /tmp/was/repository.config  \
      -installationDirectory /opt/IBM/WebSphere/AppServer \
      -preferences com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false \
    && rm -fr /tmp/was /tmp/was1.zip /tmp/was2.zip /tmp/was3.zip

###### IBM WebSphere Application Server Network Deployment Fixpack #######

# Install IBM WebSphere Application Server ND Fixpack v8559
RUN wget -q $URL/8.5.5-WS-WAS-FP0000009-part1.zip -O /tmp/wasfp1.zip \
    && wget -q $URL/8.5.5-WS-WAS-FP0000009-part2.zip -O /tmp/wasfp2.zip \
    && mkdir /tmp/wasfp \
    && unzip -qd /tmp/wasfp /tmp/wasfp1.zip  \
    && unzip -qd /tmp/wasfp /tmp/wasfp2.zip \
    && /opt/IBM/InstallationManager/eclipse/tools/imcl -showProgress \
      -acceptLicense install com.ibm.websphere.ND.v85 \
      -repositories /tmp/wasfp/repository.config  \
      -installationDirectory /opt/IBM/WebSphere/AppServer \
      -preferences com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false \
    && rm -fr /tmp/wasfp /tmp/wasfp1.zip /tmp/wasfp2.zip

########################### Install Java SDK 7.1 ########################

# Install Java SDK 7.1
RUN wget -q $URL/7.1.3.30-WS-IBMWASJAVA-part1.zip -O /tmp/java1.zip \
    && wget -q $URL/7.1.3.30-WS-IBMWASJAVA-part2.zip -O /tmp/java2.zip \
    && mkdir /tmp/java \
    && unzip -qd /tmp/java /tmp/java1.zip  \
    && unzip -qd /tmp/java /tmp/java2.zip \
    && /opt/IBM/InstallationManager/eclipse/tools/imcl -showProgress \
      -acceptLicense install com.ibm.websphere.IBMJAVA.v71 \
      -repositories /tmp/java/repository.config \
      -installationDirectory /opt/IBM/WebSphere/AppServer \
      -preferences com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false \
    && rm -fr /tmp/java /tmp/java1.zip /tmp/java2.zip

CMD ["tar","cvf","/tmp/was.tar","/opt/IBM/WebSphere/AppServer"]
