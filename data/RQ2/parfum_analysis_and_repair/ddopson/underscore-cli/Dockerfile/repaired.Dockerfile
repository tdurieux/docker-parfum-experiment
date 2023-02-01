FROM node
COPY . /source
RUN cd /source && npm install -g && npm cache clean --force;
ENTRYPOINT ["/usr/local/bin/underscore"]
