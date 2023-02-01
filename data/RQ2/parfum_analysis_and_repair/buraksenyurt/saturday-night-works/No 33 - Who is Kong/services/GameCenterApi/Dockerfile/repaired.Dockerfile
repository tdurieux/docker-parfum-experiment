FROM node:carbon

# create work directory
WORKDIR /usr/src/app

# copy package.json
COPY package.json ./
RUN npm install && npm cache clean --force;

# copy source code
COPY . .

EXPOSE 65002

CMD ["npm", "start"]