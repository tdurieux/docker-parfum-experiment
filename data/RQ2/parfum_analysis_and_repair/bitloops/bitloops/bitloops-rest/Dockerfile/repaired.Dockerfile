FROM node:lts-alpine3.12

WORKDIR /usr/src/app

RUN npm install -g typescript && npm cache clean --force;

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080 80

#Build the project
RUN npm run build

# Run node server
CMD npm run start
