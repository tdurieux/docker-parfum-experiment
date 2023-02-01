FROM node:14.15.4-alpine
WORKDIR /client
COPY package*.json /client/
RUN npm install && npm cache clean --force;
COPY . /client/
EXPOSE 3000
CMD ["npm", "start"]