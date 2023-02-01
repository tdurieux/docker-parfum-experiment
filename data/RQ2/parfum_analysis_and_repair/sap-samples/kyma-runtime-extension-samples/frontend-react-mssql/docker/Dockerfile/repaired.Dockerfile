# build environment
FROM node:current-slim as build
WORKDIR /app
COPY package.json ./
COPY yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn build && yarn cache clean;

# production environment
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
RUN chmod -R 555 /usr/share/nginx/html/icons