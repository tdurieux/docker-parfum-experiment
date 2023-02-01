FROM dockerfile/nodejs-bower-gulp
RUN apt-get update && apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
RUN gem install sass

# Set the locale to UTF-8.
RUN locale-gen en_US.UTF-8
RUN update-locale en_US.UTF-8
ENV LANG en_US.UTF-8

WORKDIR /manshar-web-client
RUN npm cache clean --force
RUN npm install -g phantomjs && npm cache clean --force;
RUN npm install -g gulp && npm cache clean --force;

# Install node packages.
WORKDIR /node
ADD package.json /node/package.json
RUN npm install && npm cache clean --force;

# Install bower packages.
WORKDIR /bower
ADD bower.json /bower/bower.json
RUN bower install --allow-root

WORKDIR /manshar-web-client
