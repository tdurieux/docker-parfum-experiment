FROM node:8
COPY . /opt/app
WORKDIR /opt/app
RUN npm install && npm cache clean --force;
CMD npm start
EXPOSE 8080
