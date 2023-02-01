FROM shell-test-base
#FROM starpit/ibm-functions-shell-base

WORKDIR /tests

# auth keys
ADD .openwhisk-shell /.openwhisk-shell

ADD dist /dist

# some fake bits needed by compile.js
RUN echo "API_HOST=foo" > ~/.wskprops
RUN echo "AUTH=bar" >>  ~/.wskprops

ADD app /app
RUN cd /app && npm install --unsafe-perm && npm cache clean --force;

# remove the fake bits
RUN rm ~/.wskprops

ADD tests /tests
RUN cd /tests && npm install && npm cache clean --force;

# fold in the latest chromedriver; this file is part of the base image see tests/docker/build.sh,Dockerfile
RUN mv /chromedriver /tests/node_modules/electron-chromedriver/bin

CMD ./bin/runWithXvfb.sh
