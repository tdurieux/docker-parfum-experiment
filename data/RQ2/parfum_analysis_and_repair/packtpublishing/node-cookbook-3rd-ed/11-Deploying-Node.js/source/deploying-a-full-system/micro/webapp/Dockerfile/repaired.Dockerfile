FROM node:slim
RUN mkdir -p /home/node/service
WORKDIR /home/node/service
COPY package.json /home/node/service
RUN npm install && npm cache clean --force;
COPY . /home/node/service
CMD [ "npm", "start" ]
