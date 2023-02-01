FROM node:lts-buster
ARG BRANCH=master
RUN cd /usr/local/src/ \
  && git clone https://github.com/trendscenter/coinstac.git \
  && cd coinstac \
  && git checkout $BRANCH \
  && npm i && npm run build && npm cache clean --force;
#Set working directory
WORKDIR /usr/local/src/coinstac
