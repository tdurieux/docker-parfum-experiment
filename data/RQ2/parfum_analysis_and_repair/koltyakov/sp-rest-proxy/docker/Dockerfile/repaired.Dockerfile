FROM node:alpine
WORKDIR /usr/src/app
COPY package.json /usr/src/app
RUN npm install && npm cache clean --force;
COPY . /usr/src/app
EXPOSE 8080
CMD ["npm", "run", "proxy"]