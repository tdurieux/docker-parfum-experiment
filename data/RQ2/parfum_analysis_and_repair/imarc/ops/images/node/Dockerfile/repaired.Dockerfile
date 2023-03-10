FROM node:8.9.4

MAINTAINER Imarc <info@imarc.com>

RUN npm install -g gulp && npm cache clean --force;

COPY entrypoint /opt/entrypoint
RUN chmod 755 /opt/entrypoint

ENTRYPOINT ["/opt/entrypoint"]
