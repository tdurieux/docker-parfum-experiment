# This dockerfile is used to create a production server image
# Run docker-compose up -f docker-compose-production.yml to create a
# running instance of a production server

FROM node:7.9-alpine

ENV NPM_CONFIG_LOGLEVEL warn

WORKDIR /code/

COPY package.json .

RUN npm install

COPY . .

EXPOSE 8000

RUN npm run build

CMD ["npm", "run", "start"]
