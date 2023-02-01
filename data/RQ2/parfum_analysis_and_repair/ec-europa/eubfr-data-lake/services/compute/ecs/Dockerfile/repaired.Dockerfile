FROM node:8

# Create app directory
WORKDIR /usr/src/app

COPY . .

RUN npm install && npm cache clean --force;

CMD ["sh", "-c", "./runner.js"]
