FROM node:alpine
WORKDIR /usr/app

COPY ./package.json ./
RUN npm install && npm cache clean --force;
COPY ./ ./

CMD ["npm", "run", "dev"]
