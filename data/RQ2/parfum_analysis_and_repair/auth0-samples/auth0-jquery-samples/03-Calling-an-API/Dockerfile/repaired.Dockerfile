FROM node:8.7-alpine

WORKDIR /home/app

RUN npm install -g create-react-app && npm cache clean --force;
ADD package.json /home/app
RUN npm install && npm cache clean --force;
ADD . /home/app

CMD ["npm", "start"]

EXPOSE 3000 3001
