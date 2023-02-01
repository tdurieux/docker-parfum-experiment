FROM node:stretch

WORKDIR /web

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . /web

RUN npm install -g nodemon && npm cache clean --force;

ENV DEBUG=express:*
EXPOSE 80
#CMD [ "nodemon", "" ]
CMD ["npm", "run", "start"]
