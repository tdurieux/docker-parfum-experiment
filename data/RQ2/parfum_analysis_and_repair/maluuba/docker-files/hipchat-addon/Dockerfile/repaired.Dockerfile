FROM ubuntu
MAINTAINER Maluuba Infrastructure Team <infrastructure@maluuba.com>

# Base Packages
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y build-essential libssl-dev monit unzip vim curl ntp redis-server mongodb git python && rm -rf /var/lib/apt/lists/*;

# Install Node, NPM and Nodemon
ENV NODE_VERSION 0.11.14
RUN git clone https://github.com/joyent/node.git /usr/src/node/

RUN cd /usr/src/node && git checkout v$NODE_VERSION && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g nodemon && npm cache clean --force;
RUN npm install -g request && npm cache clean --force;
RUN rm -rf /usr/src/node

# Install ngrok
ADD https://dl.ngrok.com/linux_386/ngrok.zip /tmp/
RUN unzip /tmp/ngrok.zip -d /usr/local/bin/
ADD ngrok  /etc/monit/conf.d/ngrok
RUN ln -s /sbin/killall5 /usr/bin/killall

# Copy Hipchat Addon files
ADD package.json  /etc/hipchat/addon/
ADD README.md  /etc/hipchat/addon/
ADD web.js  /etc/hipchat/addon/

WORKDIR /etc/hipchat/addon/

# Setup project
RUN npm install && npm cache clean --force;

ADD init.sh /tmp/init.sh
RUN chmod 700 /tmp/init.sh

CMD ["/tmp/init.sh"]
