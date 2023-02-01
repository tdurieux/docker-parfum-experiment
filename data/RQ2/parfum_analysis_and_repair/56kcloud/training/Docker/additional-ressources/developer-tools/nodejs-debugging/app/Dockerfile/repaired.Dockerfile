FROM node:17.6-alpine

WORKDIR /code

RUN npm install -g nodemon@2.0.15 && npm cache clean --force;

COPY package.json /code/package.json
RUN npm install && npm ls && npm cache clean --force;
RUN mv /code/node_modules /node_modules

COPY . /code

CMD ["npm", "start"]
