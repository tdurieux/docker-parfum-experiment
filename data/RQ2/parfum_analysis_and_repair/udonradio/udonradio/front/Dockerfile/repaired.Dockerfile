FROM node:latest

ADD . /usr/src/app
WORKDIR /usr/src/app
RUN npm install && npm cache clean --force;
CMD ["npm", "run", "build", "--production"]
