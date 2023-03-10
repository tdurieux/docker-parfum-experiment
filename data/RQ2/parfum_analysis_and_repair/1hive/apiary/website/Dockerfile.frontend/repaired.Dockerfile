FROM node:12 as react-build

ARG API_URL=https://daolist.1hive.org
ENV API_URL="${API_URL}"

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=react-build /usr/src/app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
