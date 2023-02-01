FROM node:latest
WORKDIR /app
COPY package.json /app
RUN npm install && npm cache clean --force;
COPY . /app
EXPOSE 3000
RUN npm install -g nodemon && npm cache clean --force;
CMD [ "nodemon","index.js" ]
