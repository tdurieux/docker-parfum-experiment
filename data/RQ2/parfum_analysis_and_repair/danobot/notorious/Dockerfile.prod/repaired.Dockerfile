# build environment
FROM node:10.15.1 as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json /app/package.json
COPY /app/package.json /app/app/package.json
# RUN apt instad --no-cache bash
COPY /yarn.lock /app/yarn.lock
COPY /app/yarn.lock /app/app/yarn.lock
COPY babel.config.js /app/babel.config.js
COPY /internals/scripts /app/internals/scripts
COPY /app/index.tsx /app/app/index.tsx
# RUN rm -rf node_modules && yarn cache clean
COPY /configs/webpack.config.base.js /app/configs/webpack.config.base.js
COPY /configs/webpack.config.eslint.js /app/configs/webpack.config.eslint.js
COPY /configs/webpack.config.renderer.dev.babel.js /app/configs/webpack.config.renderer.dev.babel.js
COPY /configs/webpack.config.renderer.dev.dll.babel.js /app/configs/webpack.config.renderer.dev.dll.babel.js
COPY /configs/webpack.config.renderer.prod.babel.js /app/configs/webpack.config.renderer.prod.babel.js
COPY /configs/webpack.config.main.prod.babel.js /app/configs/webpack.config.main.prod.babel.js
RUN yarn --non-interactive --network-concurrency 10
COPY /configs /app/configs
COPY . /app
RUN yarn --non-interactive build-web

# production environment
FROM nginx:1.16.0-alpine
WORKDIR /usr/share/nginx/html
RUN apk update && apk upgrade && apk add --no-cache bash
COPY --from=build /app/web/dist /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY web/nginx.conf /etc/nginx/conf.d/default.conf
COPY web/gzip.conf /etc/nginx/conf.d/gzip.conf
EXPOSE 80
COPY web/env.sh .
RUN touch .env
RUN chmod +x env.sh

# Start Nginx server
CMD ["/bin/sh", "-c", "/usr/share/nginx/html/env.sh && nginx -g \"daemon off;\""]
