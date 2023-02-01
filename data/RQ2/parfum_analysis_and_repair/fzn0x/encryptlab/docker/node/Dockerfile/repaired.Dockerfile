# build environment
FROM node:10.22.1-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json /app/package.json
RUN npm install --silent && npm cache clean --force;
COPY . /app
RUN npm run build:css
CMD ["node", "./bin/www"]