FROM node:15.14.0
WORKDIR /usr/src/app
COPY package*.json .
COPY yarn.lock .
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn run build
RUN npm install -g serve && npm cache clean --force;
EXPOSE 5000
ENTRYPOINT ["serve", "-s", "build"]