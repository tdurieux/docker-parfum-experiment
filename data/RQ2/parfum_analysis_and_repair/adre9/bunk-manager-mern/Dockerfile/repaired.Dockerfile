FROM node:latest
WORKDIR /server
COPY package*.json /server/
RUN npm install && npm cache clean --force;
COPY . /server
EXPOSE 5000
CMD [ "npm" , "run" , "server" ]
