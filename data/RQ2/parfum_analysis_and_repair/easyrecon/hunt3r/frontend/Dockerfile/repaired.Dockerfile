FROM node:18-alpine3.14 as frontend

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

#COPY package.json .
#COPY package-lock.json .
#RUN npm i -g @angular/cli

RUN npm cache clean --force
COPY . .
RUN npm install && npm cache clean --force;
RUN npm i -g @angular/cli && npm cache clean --force;
RUN npm run build --prod

RUN npm i && npm run build && npm cache clean --force;



FROM nginx:latest AS hunt3rNginx

COPY --from=frontend /usr/src/app/dist/hunt3r-ui /usr/share/nginx/html
COPY ./nginx.conf  /etc/nginx/conf.d/default.conf