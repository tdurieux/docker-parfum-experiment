FROM REPLACE_BASE_VANILLA_UBUNTU

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update
RUN useradd -ms /bin/bash REPLACE_USERNAME

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

RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bc && rm -rf /var/lib/apt/lists/*;

USER REPLACE_USERNAME
WORKDIR /home/REPLACE_USERNAME/
RUN git clone https://github.com/ibmcb/cbtool.git; cd /home/REPLACE_USERNAME/cbtool; git checkout REPLACE_BRANCH
