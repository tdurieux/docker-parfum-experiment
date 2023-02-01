FROM node:10-jessie
USER root
RUN apt-get update && apt-get install -y -f
RUN wget https://ftp.us.debian.org/debian/pool/main/w/wait-for-it/wait-for-it_0.0~git20160501-1_all.deb
RUN dpkg -i ./wait-for-it_0.0~git20160501-1_all.deb

RUN npm install -g tap && npm cache clean --force;