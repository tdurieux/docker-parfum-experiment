FROM node:18-alpine

RUN apk add --no-cache \
  git

WORKDIR /simple-icons
COPY package*.json /simple-icons/
RUN npm install && npm cache clean --force;

COPY . .

ENTRYPOINT ["npm", "run", "svgo", "--", "/image.svg"]
