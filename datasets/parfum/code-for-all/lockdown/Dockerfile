# Stage 1 - the build process
FROM node:10-alpine as build-deps
WORKDIR /usr/src/app
COPY . ./
RUN npm i && npm run build

# Stage 2 - the production environment
FROM nginx:1.17-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/000-react.conf
COPY --from=build-deps /usr/src/app/build /usr/share/nginx/html
RUN sed -i -r "s/\/lockdown\//\//g" /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
