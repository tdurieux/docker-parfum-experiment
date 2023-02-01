FROM node:8.11-alpine
WORKDIR /usr/src/app
RUN apk update -q && apk add --no-cache python -q && apk add --no-cache make && apk add --no-cache g++ -q
RUN npm i -g @angular/cli@6.1.5 && npm cache clean --force;
COPY package.json package.json
RUN npm install --silent && npm cache clean --force;
COPY . .
RUN cd front-end && npm install --silent && npm rebuild node-sass && ng build && npm cache clean --force;
RUN cd ..

EXPOSE 80 443 3000
CMD [ "npm", "start" ]
