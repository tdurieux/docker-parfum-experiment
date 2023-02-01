FROM ubuntu:18.04

RUN apt update && apt install --no-install-recommends -y xvfb curl wget software-properties-common unzip && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install --no-install-recommends -y nodejs chromium-browser && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

RUN useradd bot
RUN mkdir -p /home/bot
WORKDIR /home/bot
COPY package.json .
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn build
RUN chown bot:bot /home/bot
USER bot
CMD yarn start
