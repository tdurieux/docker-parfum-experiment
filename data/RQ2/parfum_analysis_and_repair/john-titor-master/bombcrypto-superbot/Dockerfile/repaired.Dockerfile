FROM node:14
WORKDIR /bombcrypto-superbot

RUN npm update
RUN apt update

COPY . /bombcrypto-superbot

RUN yarn install && yarn cache clean;

CMD ["yarn", "run", "go"]
