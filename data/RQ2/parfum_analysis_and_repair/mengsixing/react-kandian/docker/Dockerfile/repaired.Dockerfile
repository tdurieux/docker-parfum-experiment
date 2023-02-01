FROM node
COPY . /app
WORKDIR /app
RUN npm init -y
RUN npm i express --save && npm cache clean --force;
EXPOSE 8081
CMD node app.js
