FROM node:7.2.0

RUN apt-get -qq update -y && apt-get -qq --no-install-recommends install -y telnet net-tools less vim && rm -rf /var/lib/apt/lists/*;

RUN npm --quiet install -g grunt

COPY argusWeb /usr/argus/argusWeb
WORKDIR /usr/argus/argusWeb

RUN npm --quiet install

EXPOSE 8000
CMD ["npm", "start"]
