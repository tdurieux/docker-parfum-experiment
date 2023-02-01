FROM node:12-slim
WORKDIR /usr/src/app
COPY . ./
RUN npm install && npm cache clean --force;
CMD [ "npm", "start" ]