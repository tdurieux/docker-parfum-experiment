FROM node:latest
RUN mkdir -p /usr/src/lobby && rm -rf /usr/src/lobby
WORKDIR /usr/src/lobby
COPY package.json /usr/src/lobby/
COPY package-lock.json /usr/src/lobby/
RUN npm install && npm cache clean --force;
COPY . /usr/src/lobby
EXPOSE 4000

CMD [ "npm", "start" ]