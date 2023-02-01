FROM node:11

WORKDIR /usr/src/app


COPY package*.json ./

RUN npm install && npm cache clean --force;

ENV NODE_ENV=production

COPY . .

RUN npm run build

RUN npm run build-storybook

EXPOSE 3001 3002

CMD ["npm", "start"]