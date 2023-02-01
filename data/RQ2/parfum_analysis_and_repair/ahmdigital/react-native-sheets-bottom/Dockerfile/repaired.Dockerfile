FROM node:12

WORKDIR /root/app

RUN apt-get update \
  && apt-get install --no-install-recommends -y jq \
  && rm -rf /var/lib/apt/lists/*

RUN npm i -g npm@latest && npm cache clean --force;

COPY package.json package-lock.json ./

RUN npm ci --quiet --no-optional && \
  npm cache clean --force

COPY .babelrc .eslintrc.js .npmignore rn-swipeable-panel.gif rn-swipeable-panel.png index.js ./
COPY .git ./.git
