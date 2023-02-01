FROM node:8-alpine

COPY . /opt/app

WORKDIR /opt/app

RUN npm install --only production && npm cache clean --force;

EXPOSE 5000

CMD ["npm", "start"]