FROM centos:7 as builder

ARG AAPI_END_POINT
ARG AAPI_USER
ARG AAPI_PASS
ARG AGENT_IMAGE_NAME
ARG CTM_SERVER_NAME

LABEL Description="This is a Control-M/Agent image that planned to run in K8s env"

# install basic packages
RUN yum -y install wget \
        && yum -y install telnet \
        && yum -y install unzip \
        && yum -y install sudo \
        && yum -y install net-tools \
        && yum -y install which \
        && yum -y install zlib-devel \
        && yum -y install libffi-devel \
		&& yum -y install compat-libstdc++-33.x86_64 \
		&& yum -y install psmisc \
		&& cd /usr/src \

in tall -f nodejs \
		&& curl --silent --locat \
		&& yum -y \
		&& node - \
				&& npm -v \
in tall aapi CLI \
		&& wget --no-check-certificat \
		&& npm in \
		&& ctm -v \
				&& rm -rf $AAPI_END_POINT/
cr ate controlm useruser \
		&& seradd -d /home/controlm -s \
				&&  chmod -R 755 /home/controlm \
ad  controlm user and root to soduers list \
		&& echo 'root ALL=(ALL) ALL' >> /etc/sudoers \
		&& echo 'control \
		&& yum clean all \ && rm -rf /var/cache/yum

USER controlm
WORKDIR /home/controlm

# Create AAPI env
RUN ctm env add myenv $AAPI_END_POINT $AAPI_USER $AAPI_PASS \
# install java 11
		&& sudo yum -y install java-11-openjdk \
        && java -version \
# install agent, setup will be done during statup
		&& ctm provision image $AGENT_IMAGE_NAME && echo installation ended successfully \
        && ctm env del myenv \

# Persistent connection : internal AR keep-alive
		&& echo "AR_PING_TO_SERVER_IND Y" >> /home/controlm/ctm/data/CONFIG.dat \
		&& echo "AR_PING_TO_SERVER_INTERVAL 30" >> /home/controlm/ctm/data/CONFIG.dat \
		&& echo "AR_PING_TO_SERVER_TIMEOUT 60" >> /home/controlm/ctm/data/CONFIG.dat \
# clean and uninstall java 11
		&& sudo yum -y autore \
		&& sudo yum clean all \ && rm -rf /var/cache/yum

# install kubectl
COPY  install_kubectl.sh .
RUN ./install_kubectl.sh

RUN echo "DISABLE_CM_SHUTDOWN Y" >> /home/controlm/ctm/data/CONFIG.dat \
                && touch /home/controlm/ctm/data/DISABLE_CM_SHUTDOWN_Y.cfg

# entry point script
COPY  container_agent_startup.sh .
# agent configuration file
COPY agent_configuration.json .
# ctmhostkeep alive script
COPY ctmhost_keepalive.sh .

EXPOSE 7006



USER controlm
WORKDIR /home/controlm

ENTRYPOINT /bin/bash -c "/home/controlm/container_agent_startup.sh $PERSISTENT_VOL $AAPI_END_POINT $AAPI_USER $AAPI_PASS $CTM_SERVER_NAME $CTM_HOST_NAME"


