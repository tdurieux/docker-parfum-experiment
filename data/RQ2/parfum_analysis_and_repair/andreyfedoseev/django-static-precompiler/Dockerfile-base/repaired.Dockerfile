FROM ubuntu:18.04
MAINTAINER Andrey Fedoseev <andrey.fedoseev@gmail.com>
RUN apt-get update && apt-get install --no-install-recommends -y autoconf libtool ruby-dev npm && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/nodejs /usr/local/bin/node
RUN npm install -g coffee-script@1.7.1 && npm cache clean --force;
RUN npm install -g livescript@1.4.0 && npm cache clean --force;
RUN npm install -g less@1.7.4 && npm cache clean --force;
RUN npm install -g babel-cli@6.26.0 && npm cache clean --force;
RUN npm install -g stylus@0.50.0 && npm cache clean --force;
RUN npm install -g handlebars@4.0.2 && npm cache clean --force;
RUN gem install sass -v 3.4.22
RUN gem install compass -v 1.0.1
