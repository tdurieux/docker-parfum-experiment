FROM node:12.16.3
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;
EXPOSE 3000
ENTRYPOINT ["npm","run","dev"]