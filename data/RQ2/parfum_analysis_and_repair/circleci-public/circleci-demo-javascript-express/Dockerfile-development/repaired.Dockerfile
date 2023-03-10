FROM node
MAINTAINER jaga santagostino <kandros5591@gmail.com>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app
RUN npm install && npm cache clean --force;
COPY . /usr/src/app

ENV NODE_ENV development

EXPOSE 8000
CMD ["npm", "start"]

