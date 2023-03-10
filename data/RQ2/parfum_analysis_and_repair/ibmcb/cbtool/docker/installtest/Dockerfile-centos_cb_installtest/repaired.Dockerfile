FROM REPLACE_BASE_VANILLA_CENTOS

USER root

RUN yum -y update
RUN yum -y install openssh-server && rm -rf /var/cache/yum
RUN yum -y install passwd && rm -rf /var/cache/yum
RUN yum -y install sudo && rm -rf /var/cache/yum
RUN yum -y install rsync && rm -rf /var/cache/yum

RUN useradd -ms /bin/bash REPLACE_USERNAME
RUN echo "REPLACE_USERNAME  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

#ENV OBJECTSTORE_PORT=10000
#ENV METRICSTORE_PORT=20000
#ENV LOGSTORE_PORT=30000
#ENV FILESTORE_PORT=40000
#ENV GUI_PORT=50000
#ENV API_PORT=60000
#ENV VPN_PORT=65000

#EXPOSE $OBJECTSTORE_PORT
#EXPOSE $METRICSTORE_PORT
#EXPOSE $LOGSTORE_PORT
#EXPOSE $FILESTORE_PORT
#EXPOSE $GUI_PORT
#EXPOSE $API_PORT
#EXPOSE $VPN_PORT

RUN yum install -y sudo && rm -rf /var/cache/yum
RUN yum install -y git bc && rm -rf /var/cache/yum
USER REPLACE_USERNAME
WORKDIR /home/REPLACE_USERNAME/
RUN git clone https://github.com/ibmcb/cbtool.git; cd /home/REPLACE_USERNAME/cbtool; git checkout REPLACE_BRANCH
