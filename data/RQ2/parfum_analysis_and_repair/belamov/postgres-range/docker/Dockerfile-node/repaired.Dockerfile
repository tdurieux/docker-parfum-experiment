FROM node:alpine
EXPOSE 8080
WORKDIR /app
COPY ./docs-src /app/docs-src
RUN npm install -g vuepress && npm cache clean --force;
