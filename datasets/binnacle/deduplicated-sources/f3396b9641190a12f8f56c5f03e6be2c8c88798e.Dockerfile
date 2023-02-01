FROM node:8.9.3

WORKDIR /opt/app
COPY package.json yarn.lock ./
RUN yarn install

COPY . ./

CMD ["yarn", "test"]
