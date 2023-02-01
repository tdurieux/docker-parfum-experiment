FROM node:alpine as node

WORKDIR /src
COPY . .

RUN npm install && npm run build && npm cache clean --force;

FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=node /src/dist /usr/share/nginx/html
