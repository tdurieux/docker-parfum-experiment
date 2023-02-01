FROM node:10.15.3-alpine AS builder

WORKDIR /app

COPY ./package.json ./
RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build

FROM nginx
EXPOSE 3000

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html
