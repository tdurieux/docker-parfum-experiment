FROM node:16-alpine

RUN apk --no-cache add git # just in case some modules needs to be installed using git

WORKDIR /var/www/app

COPY . .

ENV NODE_ENV=development

RUN npm install && npm cache clean --force;
RUN npm install npm@latest -g && npm cache clean --force;

RUN npm run build # bankai build to beta/dist

EXPOSE 3000

CMD ["npm", "start"]
