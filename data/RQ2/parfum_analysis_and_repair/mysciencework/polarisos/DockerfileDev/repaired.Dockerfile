FROM node:12.18.3

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pdftk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gettext-base && rm -rf /var/lib/apt/lists/*;
RUN npm install pm2 -g && npm cache clean --force;
RUN npm install gulp-cli -g && npm cache clean --force;
RUN npm install flow-bin -g && npm cache clean --force;

# support asian character
RUN apt-get install --no-install-recommends -y fonts-takao-mincho fonts-takao fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core && rm -rf /var/lib/apt/lists/*;

#CMD [ "start_polarisos.sh", "pm2-dev", "start", "pm2.json" ]
# npm install to install all node packages
# npm run watch
# gulp default
