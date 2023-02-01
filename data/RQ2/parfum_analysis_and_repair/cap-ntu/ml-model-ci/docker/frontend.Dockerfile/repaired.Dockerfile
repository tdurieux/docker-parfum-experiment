FROM node:12-alpine as compile-image
COPY frontend /frontend
WORKDIR /frontend
RUN yarn install && yarn cache clean;
RUN yarn build && yarn cache clean;

FROM nginx:stable-alpine as build-image
COPY --from=compile-image /frontend/build /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]