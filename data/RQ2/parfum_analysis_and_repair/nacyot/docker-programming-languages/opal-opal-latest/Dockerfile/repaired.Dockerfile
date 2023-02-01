# This Dockerfile base on https://github.com/jolicode/docker-images
FROM nacyot/ruby-ruby:2.1.2
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN apt-get install --no-install-recommends -y libssl-dev libfontconfig1-dev && rm -rf /var/lib/apt/lists/*;
RUN npm install -g phantomjs && npm cache clean --force;

RUN gem install opal

# Set default WORKDIR
WORKDIR /source
