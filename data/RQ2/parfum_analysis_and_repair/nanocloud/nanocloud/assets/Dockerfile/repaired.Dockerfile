FROM node:6.1.0-slim
MAINTAINER Olivier Berthonneau <olivier.berthonneau@nanocloud.com>

RUN apt-get update && \
    apt-get install --no-install-recommends -y git && \
    npm install -g bower ember-cli && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt

COPY package.json /tmp/package.json
RUN cd /tmp && npm install && npm cache clean --force;
RUN cp -a /tmp/node_modules /opt/

COPY bower.json /tmp/bower.json
RUN cd /tmp && bower install --allow-root
RUN cp -a /tmp/bower_components /opt/

COPY ./ /opt/

CMD ./node_modules/ember-cli/bin/ember build --environment=production
