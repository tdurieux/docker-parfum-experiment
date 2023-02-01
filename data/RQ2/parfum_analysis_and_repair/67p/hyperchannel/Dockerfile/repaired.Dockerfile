FROM nodesource/node:trusty
MAINTAINER Ben Kero <ben.kero@gmail.com>

ADD package.json /tmp/package.json
RUN apt-get update && apt-get install --no-install-recommends -y git-core && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp && npm install && npm cache clean --force;
RUN mkdir -p /hyperchannel && cp -a /tmp/node_modules /hyperchannel/
WORKDIR /hyperchannel
ADD . /hyperchannel

EXPOSE 4200
CMD ["/hyperchannel/node_modules/.bin/ember", "serve"]
