FROM node:12.18-alpine
LABEL maintainer="Gisela Torres"
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --silent --production && mv node_modules ../ && npm cache clean --force;
COPY . .
# RUN npm run test
EXPOSE 3000
CMD ["npm", "start"]