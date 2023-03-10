FROM node:14.16 as build

WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;
RUN npm install -g @angular/cli && npm cache clean --force;

COPY . .

RUN ng build vt-map-editor --prod --base-href /map-editor/

#######

FROM nginx:alpine

COPY --from=build /app/dist/vt-map-editor /usr/share/nginx/html/map-editor

COPY docker/nginx-vt-map-editor.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
