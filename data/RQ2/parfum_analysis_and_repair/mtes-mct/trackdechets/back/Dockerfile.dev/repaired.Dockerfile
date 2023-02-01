FROM node:14.15.4
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --quiet && npm cache clean --force;
COPY . .
CMD [ "npm", "run", "dev" ]
