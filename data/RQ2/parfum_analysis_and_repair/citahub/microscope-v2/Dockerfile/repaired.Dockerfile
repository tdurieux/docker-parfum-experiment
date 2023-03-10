FROM node:10 as node

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;
COPY . .

RUN npm run build

FROM nginx
EXPOSE 80

COPY --from=node /app/build /usr/share/nginx/html
