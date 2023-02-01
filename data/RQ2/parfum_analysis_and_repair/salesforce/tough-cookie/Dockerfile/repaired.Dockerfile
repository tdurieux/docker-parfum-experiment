FROM node:12
MAINTAINER awaterman@salesforce.com
LABEL Description="Vendor=\"Salesforce.com\" Version=\"1.0\""
RUN apt-get update && \
 apt-get install --no-install-recommends -y vim && \
mkdir /home/cookie && \
groupadd -r cookie && useradd -r -g cookie cookie && \
usermod -a -G sudo cookie && \
chown -R cookie:cookie /home/cookie && \
chmod -R a+w /usr/local/lib/node_modules && \
chmod -R a+w /usr/local/bin && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/cookie
USER cookie
RUN npm install -g istanbul && npm cache clean --force;
ENV term=xterm-256color

