FROM ubuntu

RUN apt-get update
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gconf-service libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxss1 libxtst6 libappindicator1 libnss3 libasound2 libatk1.0-0 libc6 ca-certificates fonts-liberation lsb-release xdg-utils wget curl vim && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
ADD package.json  ./
RUN npm install && npm cache clean --force;
ADD index.js ./
CMD [ "node", "index.js" ]
