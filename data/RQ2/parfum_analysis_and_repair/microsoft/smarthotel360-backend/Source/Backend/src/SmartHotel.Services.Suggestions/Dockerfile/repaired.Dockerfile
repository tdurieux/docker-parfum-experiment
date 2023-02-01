FROM node:6-alpine
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY ["package.json", "./"]
RUN npm install -g sequelize-cli && npm cache clean --force;
RUN npm install --production --silent && mv node_modules ../ && npm cache clean --force;
COPY . .
EXPOSE 80
CMD npm start