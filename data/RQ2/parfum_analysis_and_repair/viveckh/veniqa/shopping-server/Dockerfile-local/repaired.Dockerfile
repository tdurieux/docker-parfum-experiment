FROM mhart/alpine-node:8

WORKDIR /app

COPY package*.json /app/

RUN npm install && npm cache clean --force;

COPY . /app/

CMD [ "npm", "run", "devstart" ]