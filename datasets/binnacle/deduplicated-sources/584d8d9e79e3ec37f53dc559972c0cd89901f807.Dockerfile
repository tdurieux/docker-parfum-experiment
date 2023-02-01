# Stage 0, based on Node.js, to build and compile Angular
ARG sourcemaps=false

FROM node:10.16-alpine as builder
WORKDIR /app
COPY package.json /app/
RUN npm install
COPY ./ /app/
RUN npm run build -- --base-href="." --aot --source-map $sourcemaps --configuration production --progress false

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:alpine
COPY --from=builder /app/dist/sessionbrowser/ /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
