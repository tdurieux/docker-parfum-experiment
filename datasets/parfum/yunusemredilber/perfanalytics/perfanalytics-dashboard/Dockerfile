FROM node:alpine as build

WORKDIR /app

COPY package.json /app
RUN yarn install

COPY . /app
RUN npm run build

FROM nginx:1.16.0-alpine
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
