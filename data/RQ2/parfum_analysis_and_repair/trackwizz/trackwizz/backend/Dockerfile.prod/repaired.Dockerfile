# DEV Dockerfile
FROM node:12.13-alpine

ARG BACKEND_NAME_FULL
ENV BACKEND_NAME_FULL=${BACKEND_NAME_FULL}

ARG FRONTEND_NAME_FULL
ENV FRONTEND_NAME_FULL=${FRONTEND_NAME_FULL}

# Create app directory
WORKDIR /usr/app

RUN yarn global add pm2

# Install app dependencies
COPY package.json .
COPY yarn.lock .

RUN yarn install && yarn cache clean;

# Bundle app source
COPY tsconfig.json .
COPY src src

RUN yarn run build

EXPOSE 5000

CMD ["pm2-runtime","dist/app.js"]
