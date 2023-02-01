FROM node:14-alpine as build
WORKDIR /app

RUN npm install -g @angular/cli && npm cache clean --force;

COPY ./package.json .
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

FROM nginx as runtime
COPY --from=build /app/dist/client /usr/share/nginx/html
COPY ["./conf/default.conf","/etc/nginx/conf.d/default.conf"]
