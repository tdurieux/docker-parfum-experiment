FROM node:16
WORKDIR /usr/src/app
ENV PRODUCTION=true
EXPOSE 8080
EXPOSE 80
EXPOSE 443
EXPOSE 8443
COPY package*.json ./
RUN sudo npm install && npm cache clean --force;
COPY . .

CMD [ "npm", "run", "start" ]