# Development image
FROM node:lts AS dev

WORKDIR /code
COPY package.json /code/package.json
RUN yarn install --production && yarn cache clean;

COPY . /code

ENV CI=true
ENV PORT=3000

CMD ["yarn", "start"]

# Builder
FROM dev AS build
RUN yarn run build && yarn cache clean;

# Minimalistic image
FROM nginx:1.21-alpine
COPY --from=build /code/build /usr/share/nginx/html