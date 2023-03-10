FROM node:dubnium-alpine

# I need it for my eslint rules package that I'm using from git
RUN apk update
RUN apk add --no-cache git

WORKDIR '/app'

ARG FONTAWESOME_NPM_AUTH_TOKEN
COPY ./package*.json ./
# COPY ./.npmrc ./
RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "run", "start"]
