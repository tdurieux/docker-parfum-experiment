FROM node:12
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;
EXPOSE 8000
CMD [ "npm", "start" ]