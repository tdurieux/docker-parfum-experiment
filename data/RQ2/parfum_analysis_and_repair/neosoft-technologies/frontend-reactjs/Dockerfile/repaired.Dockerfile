FROM node:14-alpine AS development

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

EXPOSE 3000

CMD [ "npm", "run", "start" ]

