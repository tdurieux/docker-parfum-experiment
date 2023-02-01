FROM node:8
WORKDIR /usr/src/app
COPY ./app/* ./
RUN npm install && npm cache clean --force;
EXPOSE 80
CMD [ "npm", "start" ]