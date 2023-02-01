FROM node:8-alpine

RUN mkdir /app
# Set the working directory to /app
WORKDIR /app
COPY package.json /app
RUN npm i -g yarn && npm cache clean --force;
RUN yarn
EXPOSE 1667
