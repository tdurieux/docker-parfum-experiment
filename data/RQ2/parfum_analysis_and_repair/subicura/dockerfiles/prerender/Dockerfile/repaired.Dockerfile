FROM node:4.2.2
MAINTAINER chungsub.kim@purpleworks.co.kr

# update ubuntu latest
RUN \
  apt-get -qq update && \
  apt-get -qq -y dist-upgrade

# install essential packages
RUN \
  apt-get -qq --no-install-recommends -y install build-essential software-properties-common python-software-properties git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    python2.7 python-pip \
    libfreetype6 libfontconfig && rm -rf /var/lib/apt/lists/*;

# install prerender
RUN cd / && git clone https://github.com/prerender/prerender
WORKDIR /prerender
RUN npm install && npm cache clean --force;

# run
EXPOSE 3000
CMD ["node", "server.js"]

