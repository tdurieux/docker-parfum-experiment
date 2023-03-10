# Only used for TravisCI purposes

FROM node:lts AS build
WORKDIR /app
COPY . /app

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
        && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
        && apt-get update && apt-get -y --no-install-recommends install google-chrome-stable && rm -rf /var/lib/apt/lists/*;

RUN npm install && npm cache clean --force;
RUN npm run test:ci && npm run lint && npm run build -- --configuration=docker
