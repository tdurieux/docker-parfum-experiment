FROM node:12

RUN mkdir -p /app
WORKDIR /app

COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 4001

CMD ["npm", "start"]
