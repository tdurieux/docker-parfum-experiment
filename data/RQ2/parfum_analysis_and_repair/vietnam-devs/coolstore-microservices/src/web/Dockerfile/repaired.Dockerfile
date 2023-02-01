FROM node:16-alpine
WORKDIR /usr/server/app

COPY ./package.json ./
RUN npm install -g npm@8.8.0 && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY ./ .
RUN npm run build
ENV NODE_ENV=production

CMD ["npm", "run" ,"start"]
