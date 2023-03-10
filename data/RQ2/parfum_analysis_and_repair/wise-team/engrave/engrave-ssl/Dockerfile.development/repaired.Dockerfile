FROM node:alpine

RUN npm install -g typescript nodemon && npm cache clean --force;

WORKDIR /app
COPY package*.json ./
COPY tsconfig.json ./
RUN npm install && npm cache clean --force;

COPY src src

RUN npm run build

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.4.0/wait /wait
RUN chmod +x /wait

## Launch the wait tool and then your application
CMD /wait && npm run watch