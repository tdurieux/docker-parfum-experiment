FROM node:alpine

WORKDIR /app
COPY package.json .
RUN npm install --only=prod && npm cache clean --force;
COPY . .

CMD ["npm", "run", "start"]