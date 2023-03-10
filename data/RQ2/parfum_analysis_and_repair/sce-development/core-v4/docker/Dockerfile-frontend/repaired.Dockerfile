FROM node:14-alpine as builder

WORKDIR /frontend

COPY ./package.json /frontend/package.json
COPY ./package-lock.json /frontend/package-lock.json

RUN npm install --production && npm cache clean --force;

COPY public ./public
COPY util ./util
COPY src ./src

RUN npm run build --production

# stage 2
FROM nginx:alpine

COPY ./docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /frontend/build /usr/share/nginx/html

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
