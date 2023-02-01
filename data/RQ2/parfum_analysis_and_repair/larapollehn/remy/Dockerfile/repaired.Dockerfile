FROM node:alpine as build

WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

FROM nginx:alpine

COPY --from=build /app/build/ /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
