FROM mhart/alpine-node:9

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app
RUN npm install && npm cache clean --force;
COPY . /usr/src/app
RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "prod"]
