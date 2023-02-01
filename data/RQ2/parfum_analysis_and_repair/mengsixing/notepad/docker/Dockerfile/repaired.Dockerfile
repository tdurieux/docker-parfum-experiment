FROM mhart/alpine-node
COPY . /app
WORKDIR /app
RUN npm init -y
RUN npm i finalhandler --save && npm cache clean --force;
RUN npm i serve-static --save && npm cache clean --force;
EXPOSE 8083
CMD node app.js
