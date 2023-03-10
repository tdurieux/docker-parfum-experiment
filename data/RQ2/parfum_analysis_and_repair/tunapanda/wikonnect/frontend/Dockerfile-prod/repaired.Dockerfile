FROM node:fermium-alpine3.12

ARG NODE_ENV

WORKDIR /usr/src/app/

RUN yarn global add ember-cli && yarn cache clean;

COPY package.json yarn.lock ./

RUN yarn --frozen-lockfile && yarn cache clean;

COPY . .

RUN ember build --prod


#Copy the dist folder to new NGINX image

FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html

COPY --from=0 /usr/src/app/dist .

EXPOSE 80
