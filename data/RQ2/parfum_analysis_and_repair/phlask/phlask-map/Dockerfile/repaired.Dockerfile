FROM node:16-slim

WORKDIR /usr/src/app

COPY package*.json ./

# RUN useradd app

RUN apt-get update && apt-get install --no-install-recommends -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb python3 && rm -rf /var/lib/apt/lists/*;

RUN yarn install && yarn cache clean;

COPY . .

EXPOSE 8080

ENTRYPOINT yarn start

