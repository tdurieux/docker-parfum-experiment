FROM node:10.16-stretch as builder

RUN npm install -g @angular/cli && npm cache clean --force;

COPY webapp/src /app/src/
COPY webapp/tsconfig.json /app/
COPY webapp/tsconfig.app.json /app/
COPY webapp/package.json /app/
COPY webapp/angular.json /app/
COPY webapp/tslint.json /app/

WORKDIR /app

RUN npm install && ng build --prod && npm cache clean --force;

FROM nginx:1.17.1

COPY webapp/nginx/default.conf /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist/company-structure /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
