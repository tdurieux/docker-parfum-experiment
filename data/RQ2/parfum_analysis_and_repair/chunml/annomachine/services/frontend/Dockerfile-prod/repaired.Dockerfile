FROM node:12.10.0-alpine as builder

WORKDIR /usr/src/app

ENV path /usr/src/app/node_modules/.bin:$PATH

COPY package.json .
COPY yarn.lock .
RUN yarn && yarn cache clean;

ARG REACT_APP_API_URL
ENV REACT_APP_API_URL $REACT_APP_API_URL
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

COPY . /usr/src/app

RUN yarn build && yarn cache clean;

FROM nginx:1.15.9-alpine

RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx

COPY --from=builder /usr/src/app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]