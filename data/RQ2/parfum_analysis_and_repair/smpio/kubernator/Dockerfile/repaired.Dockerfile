# Builder

FROM node:14 as builder

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;

COPY . .
RUN yarn build && yarn cache clean;
RUN rm ./build/static/**/*.map


# Runner

FROM nginx
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
