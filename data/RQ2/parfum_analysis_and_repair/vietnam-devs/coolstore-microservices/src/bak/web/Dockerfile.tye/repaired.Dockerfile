FROM node:10.16 as node-build
WORKDIR /app

COPY package-lock.json .
COPY package.json .
RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build

FROM node-build as publish

FROM nginx:perl as final
WORKDIR /app

RUN nginx -v

COPY --from=publish /app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=publish /app/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=publish /app/build /app

CMD ["nginx", "-g", "daemon off;"]
