# DEV Dockerfile
FROM node:12.13-alpine

# Create app directory
WORKDIR /usr/app

# Install app dependencies
COPY package.json .
COPY yarn.lock .

RUN yarn install && yarn cache clean;

# Bundle app source
COPY tsconfig.json .
COPY .eslintignore .
COPY .eslintrc.js .
COPY nodemon.json .
COPY .prettierrc.js .
COPY jest.config.js .

COPY __tests__ __tests__
COPY src src

EXPOSE 5000
CMD [ "yarn", "start" ]
