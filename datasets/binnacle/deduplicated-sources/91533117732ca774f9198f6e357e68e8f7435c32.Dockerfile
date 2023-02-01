FROM chandanibm/docker-android-nodejs  
  
MAINTAINER Maik Hummel <m@ikhummel.com>  
  
ENV CORDOVA_VERSION 6.5.0  
WORKDIR "/tmp"  
  
RUN npm i -g --unsafe-perm cordova@${CORDOVA_VERSION}

