# Update on docker hub with the following commands in the directory of this file:
# docker build -t matrixdotorg/riotweb-ci-e2etests-env:latest .
# docker log
# docker push matrixdotorg/riotweb-ci-e2etests-env:latest
FROM node:10
RUN apt-get update
RUN apt-get -y --no-install-recommends install build-essential python3-dev libffi-dev python-pip python-setuptools sqlite3 libssl-dev python-virtualenv libjpeg-dev libxslt1-dev uuid-runtime && rm -rf /var/lib/apt/lists/*;
# dependencies for chrome (installed by puppeteer)
RUN apt-get -y --no-install-recommends install gconf-service libasound2 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget && rm -rf /var/lib/apt/lists/*;
