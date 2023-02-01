FROM ubuntu:latest

RUN mkdir /var/www/
RUN mkdir /var/www/DiscordEarsBot
WORKDIR /var/www/DiscordEarsBot

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y git vim g++ cmake && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install curl dirmngr apt-transport-https lsb-release ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/healzer/DiscordEarsBot.git .
RUN npm install && npm cache clean --force;
RUN npm update
RUN npm install pm2@latest -g && npm cache clean --force;

# provide API credentials through the settings.json file OR the environment variables:

# COPY settings.json /var/www/DiscordEarsBot/settings.json

# ENV DISCORD_TOK=
# ENV WITAPIKEY=

CMD git pull && npm update && pm2 start ecosystem.config.js
