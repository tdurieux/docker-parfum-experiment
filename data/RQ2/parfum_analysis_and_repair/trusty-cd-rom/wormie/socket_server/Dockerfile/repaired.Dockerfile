FROM node

RUN mkdir app

WORKDIR app

ADD . /app/

RUN npm install && npm cache clean --force;

EXPOSE 8083

CMD ["npm", "start"]
