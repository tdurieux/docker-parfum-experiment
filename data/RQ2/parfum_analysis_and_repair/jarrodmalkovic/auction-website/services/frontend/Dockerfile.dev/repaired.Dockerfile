FROM node:14.15.5-alpine3.10
ENV CI=true

WORKDIR /app
COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .

CMD ["npm", "run", "dev"]