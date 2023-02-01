FROM node:10
WORKDIR /build
COPY ./package.json .
RUN npm install && npm cache clean --force;
COPY . .
ENTRYPOINT npm run prod-pack
