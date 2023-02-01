FROM node:12

WORKDIR /home/app

ADD package.json /home/app
RUN npm install && npm cache clean --force;
ADD . /home/app

CMD ["npm", "start"]

EXPOSE 3010
