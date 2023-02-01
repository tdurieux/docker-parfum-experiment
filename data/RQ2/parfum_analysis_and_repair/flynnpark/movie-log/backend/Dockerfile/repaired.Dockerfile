FROM node:10

RUN curl -f -o- -L https://yarnpkg.com/install.sh | bash

WORKDIR /usr/src/app
COPY package*.json yarn.lock ./

RUN yarn global add nodemon && yarn cache clean;

RUN yarn && yarn cache clean;

COPY . .

EXPOSE 4000

CMD ["yarn", "dev"]