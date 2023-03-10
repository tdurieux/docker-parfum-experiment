FROM node:lts-alpine3.12

WORKDIR /app
COPY package.json ./
# RUN npm install --only=prod --silent

RUN npm install --silent && npm cache clean --force;
COPY ./ ./
CMD ["npm", "run", "start"]