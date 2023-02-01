FROM node:12.13.0 as build
LABEL maintainer="1029765111@qq.com"
WORKDIR /usr/src/app

COPY ./package.json .
COPY ./docs ./docs

RUN npm config set registry https://registry.npm.taobao.org

RUN npm install && \
    npm run docs:build && npm cache clean --force;

FROM nginx:latest
LABEL maintainer="1029765111@qq.com"
WORKDIR /usr/app
COPY --from=build /usr/src/app/docs/.vuepress/dist .
COPY --from=build /usr/src/app/docs/nginx-docs.conf /etc/nginx/nginx.conf
ENV HOST 0.0.0.0
EXPOSE 80
ENTRYPOINT ["nginx","-g","daemon off;"]