FROM node:12
WORKDIR /app
COPY package.json /app
RUN npm install && npm cache clean --force;
COPY . /app
EXPOSE 8900
CMD npm start
