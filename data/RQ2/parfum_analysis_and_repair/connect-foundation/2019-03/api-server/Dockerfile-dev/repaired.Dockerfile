FROM node:10.17

RUN mkdir /usr/src/server && rm -rf /usr/src/server
WORKDIR /usr/src/server
ENV NODE_ENV=development

COPY package.json /usr/src/server/package.json
RUN npm install && npm cache clean --force;

COPY . /usr/src/server

CMD ["npm", "run", "dev"]