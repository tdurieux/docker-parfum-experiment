FROM node:10.5.0

WORKDIR /usr/src/app

RUN npm install -g typescript && npm cache clean --force;

RUN npm install -g nodemon && npm cache clean --force;

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 4040 5550

#Build to project
RUN npm run build

# Run node server
CMD npm run start
