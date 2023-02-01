FROM node:10.1
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD npm start