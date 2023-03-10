from node:8
MAINTAINER Joe Miyamoto <joemphilips@gmail.com>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install --no-progress && npm cache verify && npm cache clean --force;

COPY . /usr/src/app/

EXPOSE 3000

CMD ["npm", "start"]
