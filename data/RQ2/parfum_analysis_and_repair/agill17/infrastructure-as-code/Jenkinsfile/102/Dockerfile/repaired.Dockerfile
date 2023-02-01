FROM node:4.6
WORKDIR /app
ADD . /app
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD npm start
