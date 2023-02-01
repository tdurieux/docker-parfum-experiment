FROM mhart/alpine-node:8

WORKDIR /app
COPY . /app

RUN npm install && npm cache clean --force;

EXPOSE 3000
CMD ["node", "app.js"]
