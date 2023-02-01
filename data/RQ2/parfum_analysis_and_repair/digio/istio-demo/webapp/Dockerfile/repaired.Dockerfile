FROM node:10.12.0 as build-deps

WORKDIR /usr/src/app
COPY package.json yarn.lock ./

RUN yarn && yarn cache clean;
COPY . ./
EXPOSE 3000
CMD ["npm", "run", "start"]
