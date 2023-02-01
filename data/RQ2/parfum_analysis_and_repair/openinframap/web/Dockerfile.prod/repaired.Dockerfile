FROM node:14 AS build
WORKDIR /app
COPY . .
RUN npm install -g npm@latest && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm run build

FROM nginx:mainline-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx-site.conf /etc/nginx/conf.d/default.conf
