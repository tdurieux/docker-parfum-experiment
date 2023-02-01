FROM node:12.22.6-alpine

RUN npm install -g gatsby-cli && npm cache clean --force;
WORKDIR /app

ADD package.json package-lock.json /app/

RUN npm install && npm cache clean --force;
ADD . /app

CMD ["npm", "run", "dev"]
