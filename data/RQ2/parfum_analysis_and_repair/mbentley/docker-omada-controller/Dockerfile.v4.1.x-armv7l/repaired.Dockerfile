# rebased/repackaged base image that only updates existing packages
FROM mbentley/ubuntu:16.04
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

# install omada controller (instructions taken from install.sh); then create a user & group and set the appropriate file system permissions
RUN \
  echo "**** Install Dependencies ****" &&\
  apt-get update &&\
  DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y gosu mongodb net-tools openjdk-8-jre-headless tzdata wget &&\
  rm -rf /var/lib/apt/lists/* &&\
  echo "**** Download Omada Controller ****" &&\
  cd /tmp &&\
  wget -nv "https://static.tp-link.com/2020/202007/20200714/Omada_SDN_Controller_v4.1.5_linux_x64.tar.gz" &&\
  echo "**** Extract and Install Omada Controller ****" &&\
  tar zxvf Omada_SDN_Controller_v4.1.5_linux_x64.tar.gz &&\
  rm Omada_SDN_Controller_v4.1.5_linux_x64.tar.gz &&\
  cd Omada_SDN_Controller_* &&\
  mkdir /opt/tplink/EAPController -vp &&\
  cp bin /opt/tplink/EAPController -r &&\
  cp data /opt/tplink/EAPController -r &&\
  cp properties /opt/tplink/EAPController -r &&\
  cp webapps /opt/tplink/EAPController -r &&\
  cp keystore /opt/tplink/EAPController -r &&\
  cp lib /opt/tplink/EAPController -r &&\
  cp install.sh /opt/tplink/EAPController -r &&\
  cp uninstall.sh /opt/tplink/EAPController -r &&\
  ln -sf "$(which mongod)" /opt/tplink/EAPController/bin/mongod &&\
  chmod 755 /opt/tplink/EAPController/bin/* &&\
  echo "**** Cleanup ****" &&\
  cd /tmp &&\
  rm -rf /tmp/Omada_SDN_Controller*

# patch log4j vulnerability