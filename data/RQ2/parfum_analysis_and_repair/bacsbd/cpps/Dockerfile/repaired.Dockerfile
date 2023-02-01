FROM node:8
LABEL maintainer="forthright48@gmail.com"

WORKDIR /home/src

RUN apt update

RUN apt install --no-install-recommends -y gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get -y --no-install-recommends install yarn && rm -rf /var/lib/apt/lists/*;

RUN yarn global add forever

RUN npm install -g gulp-cli && npm cache clean --force;

COPY package.json .
RUN yarn install && yarn cache clean;

COPY client client
RUN cd client/modules/coach && yarn install && yarn build && cd - && cd client/ && mkdir -p build && cd build && cp ../modules/coach/build -r coach && yarn cache clean;

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb
RUN dpkg -i dumb-init_*.deb

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

ADD . .

EXPOSE 8002
EXPOSE 3000
EXPOSE 3050
