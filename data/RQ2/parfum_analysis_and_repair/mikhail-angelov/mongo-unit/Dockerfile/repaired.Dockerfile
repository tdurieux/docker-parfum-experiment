FROM node:10

WORKDIR /app

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
RUN npm install && npm cache clean --force;
COPY . /app

CMD npm test