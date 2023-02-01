FROM node:12
WORKDIR /usr/src/app

COPY package.json ./
RUN npm install && npm cache clean --force;
COPY . .

CMD npm start

# psql
RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;