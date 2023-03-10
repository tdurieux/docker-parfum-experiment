FROM node:10-alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm i --production && npm cache clean --force;
COPY . /usr/src/app
EXPOSE 3000
ENV NODE_ENV production
CMD ["npm", "start"]
