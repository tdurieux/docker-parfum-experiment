FROM node:15

WORKDIR /app

COPY package.json ./
RUN npm install -g increase-memory-limit && npm cache clean --force;
RUN increase-memory-limit
RUN npm update
RUN npm install --silent && npm cache clean --force;


COPY . ./

ENTRYPOINT ["npm","start"]
