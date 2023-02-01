FROM node:11.1.0

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json ./
COPY yarn.lock ./

RUN yarn --frozen-lockfile && yarn cache clean;
RUN yarn global add forever && yarn cache clean;

# Bundle app source
COPY . .

RUN yarn build && yarn cache clean;

EXPOSE 3000
CMD [ "forever", "ts/lib/src/index.js" ]
