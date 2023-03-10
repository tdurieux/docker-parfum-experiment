FROM node:12.19-alpine

# Create workdir
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Add application
COPY package.json yarn.lock /usr/src/app/
RUN yarn install --non-interactive && yarn cache clean
COPY . /usr/src/app

CMD [ "yarn", "server" ]
