FROM node:lts As development
WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

FROM node:lts as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY package*.json ./

RUN npm install --only=production && npm cache clean --force;

COPY . .

COPY --from=development /app/dist ./dist

RUN mkdir /app/logs

CMD ["node", "dist/app.js"]
