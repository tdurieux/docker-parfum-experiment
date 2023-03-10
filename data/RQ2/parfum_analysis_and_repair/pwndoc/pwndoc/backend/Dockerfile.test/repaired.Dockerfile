FROM node:lts-alpine

RUN mkdir -p /app
WORKDIR /app
COPY package*.json ./
RUN apk --no-cache add --virtual builds-deps build-base python3 git
ENV NODE_ENV test
ENV NODE_ICU_DATA=node_modules/full-icu
RUN npm install && npm cache clean --force;
ENTRYPOINT ["npm", "run", "test"]