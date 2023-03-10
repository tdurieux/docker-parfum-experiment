FROM node:11

RUN mkdir /app
WORKDIR /app
COPY . .

RUN npm install && npm cache clean --force;
CMD [ "npm", "run", "dev" ]