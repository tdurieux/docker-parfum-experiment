FROM mhart/alpine-node:14

RUN mkdir -p /home/app

WORKDIR /home/app

COPY build ./build
COPY public ./public
COPY package.json .

RUN yarn install --frozen-lockfile --production

EXPOSE 4500

ENTRYPOINT ["node", "build/index.js"]