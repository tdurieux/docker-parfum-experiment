FROM ubuntu:14.04

RUN mkdir /usr/src/app && rm -rf /usr/src/app
RUN mkdir /usr/src/app/client && rm -rf /usr/src/app/client
WORKDIR /usr/src/app/client


RUN apt-get update && apt-get install --no-install-recommends -y git npm nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential chrpath git-core libssl-dev libfontconfig1-dev && rm -rf /var/lib/apt/lists/*;

RUN npm install -g bower && npm cache clean --force;
RUN npm install -g grunt-cli && npm cache clean --force;
RUN npm install -g grunt && npm cache clean --force;

RUN apt-get install --no-install-recommends -y ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install compass
RUN ln -s /usr/bin/nodejs /usr/bin/node
#RUN mkdir /usr/src/app/client
COPY bower.json /usr/src/app/client/
RUN bower install --allow-root
COPY package.json /usr/src/app/client/
RUN npm install && npm cache clean --force;
COPY Gruntfile.js /usr/src/app/client/
CMD grunt dev
COPY . /usr/src/app/client
EXPOSE 9000
