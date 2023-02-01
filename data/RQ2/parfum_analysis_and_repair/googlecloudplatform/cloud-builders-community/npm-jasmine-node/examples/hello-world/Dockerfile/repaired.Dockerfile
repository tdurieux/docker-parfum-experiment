FROM node:4.2.3

WORKDIR /app

COPY package.json /app/
RUN npm install && npm cache clean --force;
COPY . /app

EXPOSE 3000

ENTRYPOINT ["npm", "start"]