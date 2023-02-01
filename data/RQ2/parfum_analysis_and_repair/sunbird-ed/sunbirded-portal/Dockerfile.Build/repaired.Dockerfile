#Dockerfile for the player setup
FROM node:12.16.1
MAINTAINER "Rajesh Rajendran <rajesh.r@optit.co>"
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install --no-install-recommends -y --force-yes python python-dev autoconf g++ make nasm bzip2 \
    && useradd jenkins && rm -rf /var/lib/apt/lists/*;
RUN npm i -g npm@6.13.4 && npm cache clean --force;
RUN mkdir -p /home/jenkins
WORKDIR /home/jenkins
COPY * /home/jenkins/
RUN chown -R jenkins:jenkins /home/jenkins
USER jenkins
WORKDIR /home/jenkins/app
RUN npm set progress=false
RUN npm install --unsafe-perm && npm cache clean --force;
RUN npm run deploy
WORKDIR /home/jenkins/app/app_dist
RUN npm install --production --unsafe-perm && npm cache clean --force;
WORKDIR /home/jenkins/app
# passing commit hash as build arg
ARG commit_hash=0
ENV commit_hash ${commit_hash}
CMD ["/bin/bash","-x","../vcs-config.sh"]
