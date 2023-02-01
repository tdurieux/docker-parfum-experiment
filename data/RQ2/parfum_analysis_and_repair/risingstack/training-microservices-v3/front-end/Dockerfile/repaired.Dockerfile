FROM node:boron-stretch as builder
COPY package.json package.json
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

FROM nginx
COPY --from=builder build/ /usr/share/nginx/www/
COPY nginx.conf /etc/nginx/nginx.conf
