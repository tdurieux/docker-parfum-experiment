FROM ubuntu:18.04

RUN apt update && apt install --no-install-recommends -y xvfb curl wget software-properties-common unzip && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:canonical-chromium-builds/stage
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt install --no-install-recommends -y ca-certificates fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils && rm -rf /var/lib/apt/lists/*;
RUN wget 'https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F870763%2Fchrome-linux.zip?generation=1617926496067901&alt=media' -O /chrome.zip
RUN unzip /chrome.zip
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
# ^^^ chromium-browser=91.0.4472.101-0ubuntu0.18.04.1
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

RUN useradd bot
RUN mkdir -p /bot
RUN chown bot:bot /bot

WORKDIR /bot
COPY ./bot/bot.js .
COPY ./bot/package.json .
RUN npm cache clean --force
RUN npm install && npm cache clean --force;
CMD xvfb-run node bot.js
