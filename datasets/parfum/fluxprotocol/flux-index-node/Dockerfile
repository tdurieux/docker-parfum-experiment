FROM node:12
WORKDIR /usr/src/app

COPY package.json ./
RUN npm install
COPY . .

CMD npm start

# psql
RUN apt-get update && apt-get install -y postgresql-client