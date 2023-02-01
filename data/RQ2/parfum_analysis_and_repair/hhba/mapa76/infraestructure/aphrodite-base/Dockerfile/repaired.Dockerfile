FROM ruby:2.1.5
MAINTAINER marcosvanetta@gmail.com

RUN apt-get update -q && apt-get install --no-install-recommends -y nodejs npm git git-core && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm config set registry http://registry.npmjs.org
RUN npm install -g grunt-cli && npm cache clean --force;
