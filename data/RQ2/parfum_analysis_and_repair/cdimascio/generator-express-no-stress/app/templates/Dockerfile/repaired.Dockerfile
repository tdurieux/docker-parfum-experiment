FROM node:14-alpine
LABEL Author Carmine DiMascio <cdimascio@gmail.com>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD [ "npm", "start" ]
