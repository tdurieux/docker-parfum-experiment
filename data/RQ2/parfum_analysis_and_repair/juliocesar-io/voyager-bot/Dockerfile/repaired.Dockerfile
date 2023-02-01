FROM resin/rpi-raspbian:wheezy
MAINTAINER Julio César <julioc255io@gmail.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Install Nodejs 0.10.xx for compatibility with serialport
RUN wget https://node-arm.herokuapp.com/node_0.10.36-1_armhf.deb
RUN dpkg -i node_0.10.36-1_armhf.deb

# Install Arduino
RUN apt-get install --no-install-recommends -y --force-yes arduino && rm -rf /var/lib/apt/lists/*;

# Install node modules
WORKDIR /usr/src/voyager-bot/
COPY . /usr/src/voyager-bot/
RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD ["node", "/usr/src/voyager-bot/app.js"]
