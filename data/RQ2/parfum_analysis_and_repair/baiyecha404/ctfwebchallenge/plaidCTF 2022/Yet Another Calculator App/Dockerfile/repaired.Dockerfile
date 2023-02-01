FROM node:lts

RUN apt-get update && apt-get install --no-install-recommends -y libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2 && rm -rf /var/lib/apt/lists/*;

WORKDIR /problem
ADD .yarnrc.yml .
ADD .yarn ./.yarn/
ADD package.json .
ADD yarn.lock .

RUN yarn

ADD . .
RUN yarn build

CMD ["yarn", "start"]
