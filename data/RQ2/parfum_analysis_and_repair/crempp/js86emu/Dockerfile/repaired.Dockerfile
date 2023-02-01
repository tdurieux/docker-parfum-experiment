FROM node:15.5.1-alpine3.10

WORKDIR /app
COPY . /app

RUN npm install && npm cache clean --force;
RUN npm run build:web

EXPOSE 8080

# Launch application
CMD ["npm","run","start:web"]
