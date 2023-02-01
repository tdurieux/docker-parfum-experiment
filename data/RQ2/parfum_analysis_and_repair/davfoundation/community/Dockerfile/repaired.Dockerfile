FROM node:8.4.0

RUN mkdir /app
WORKDIR /app

COPY package.json /app/
RUN npm install && npm cache clean --force;

COPY . /app

EXPOSE 3000

CMD ["npm", "start"]
