FROM node:latest as build-stage
WORKDIR /opt
COPY . .
RUN npm install --unsafe-perm=true --allow-root --legacy-peer-deps --registry https://registry.npm.taobao.org
RUN npm run build


FROM nginx:latest as production-stage

RUN apt update && apt install -y nano telnet

# remove the default config
RUN rm /etc/nginx/conf.d/default.conf && rm /etc/nginx/nginx.conf

# create new root folder
RUN mkdir -p /var/www/myems-web

COPY nginx.conf /etc/nginx/
COPY --from=build-stage /opt/build/ /var/www/myems-web
EXPOSE 80
CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]