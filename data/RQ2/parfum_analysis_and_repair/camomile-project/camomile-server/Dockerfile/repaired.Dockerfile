FROM node:0.10

RUN mkdir -p /app

WORKDIR /app

COPY package.json /app/
RUN npm install && npm cache clean --force;
COPY . /app/

EXPOSE 3000

CMD ["node", "/app/app.js"]
