FROM ibmcom/ibmnode:latest
MAINTAINER Scott Graham <swgraham@us.ibm.com>
#
#  This is the watson-multimedia-analyzer image
#
ENV NODE_ENV production
ADD . /watson-multimedia-analyzer
WORKDIR /watson-multimedia-analyzer

RUN apt-get update \
  && apt-get -y --no-install-recommends install vim \
  && apt-get -y --no-install-recommends install ffmpeg \
  && apt-get -y --no-install-recommends install curl \
  && apt-get clean \
  && npm install \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && npm cache clean --force;

EXPOSE 8080
CMD ["node" , "app.js"]