FROM node:14.16 as build

WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;
RUN npm install -g @angular/cli && npm cache clean --force;

COPY . .

RUN ng build vt-map-view --prod --base-href /map-view/

#######

FROM nginx:alpine

COPY --from=build /app/dist/vt-map-view /usr/share/nginx/html/map-view

COPY docker/nginx-vt-map-view.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
