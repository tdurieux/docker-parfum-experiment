FROM node:15.5.1-alpine3.10

WORKDIR /app
COPY . /app

RUN npm install && npm cache clean --force;

# Launch application
CMD ["./node_modules/.bin/jest","--coverage"]
