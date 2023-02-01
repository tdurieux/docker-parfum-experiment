FROM node:8

RUN npm install -g gitbook-cli && npm cache clean --force;

# init gitbook
RUN mkdir /tmp/test
RUN cd /tmp/test && gitbook init
RUN rm -r /tmp/test
