FROM node:latest

# set working directory
WORKDIR /usr/src/app

# copy yarn stuff
COPY package.json ./
COPY yarn.lock ./

RUN yarn install -s && yarn cache clean;

COPY . .

EXPOSE 3000

# start app
CMD ["yarn", "start"]
