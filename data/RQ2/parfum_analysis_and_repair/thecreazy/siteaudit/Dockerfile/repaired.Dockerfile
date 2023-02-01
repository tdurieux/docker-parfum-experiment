FROM markhobson/node-chrome:latest

WORKDIR /app

RUN npm install --global yarn && npm cache clean --force;
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
RUN yarn

COPY . /app
RUN yarn link && yarn cache clean;

RUN google-chrome \
  --headless \
  --hide-scrollbars \
  --disable-gpu \
  --no-sandbox

ENTRYPOINT ["/usr/local/bin/siteaudit"]

