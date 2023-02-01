FROM node:dubnium-alpine

# I need it for my eslint rules package that I'm using from git
RUN apk update && apk add --no-cache git

ENV NODE_ENV=production

COPY ./package*.json ./app/

WORKDIR '/app'
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

WORKDIR '/app/server'
RUN npm install && npm cache clean --force;

ENV PORT=8080
EXPOSE $PORT

CMD ["npm", "run", "start"]
