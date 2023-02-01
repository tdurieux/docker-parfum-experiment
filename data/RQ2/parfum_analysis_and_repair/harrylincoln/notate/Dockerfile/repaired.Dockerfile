# Stage 1 - the build process
FROM node:10.16.0 as build-deps
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . ./
RUN yarn build && yarn cache clean;

# Stage 2 - the production environment
FROM nginx:1.12-alpine
COPY --from=build-deps /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
