FROM node:6.2.2
WORKDIR /app
ADD . /app
RUN npm install && npm cache clean --force;
EXPOSE 300
CMD npm start
