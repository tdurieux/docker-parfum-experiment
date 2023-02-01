FROM node
WORKDIR /node-boilerplate
COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 8080
CMD npm start
