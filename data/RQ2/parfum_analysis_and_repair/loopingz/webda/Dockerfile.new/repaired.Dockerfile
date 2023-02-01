FROM node:latest
MAINTAINER loopingz@loopingz.com

RUN apt-get update \
 && apt-get install --no-install-recommends -y libpixman-1-dev libcairo2-dev libpangocairo-1.0-0 libpango1.0-dev libgif-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /server/
ADD . /server/

RUN cd /server && npm install && npm cache clean --force;
RUN mkdir /etc/webda
CMD cd /server && node server.js  > /data/webda.log
