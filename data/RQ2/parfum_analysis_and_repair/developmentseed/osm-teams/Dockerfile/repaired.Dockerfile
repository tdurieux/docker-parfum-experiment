FROM node:14

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json ./

RUN npm install -g nodemon && npm cache clean --force;
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

RUN npm run build

EXPOSE 8989
CMD [ "npm", "start"]
