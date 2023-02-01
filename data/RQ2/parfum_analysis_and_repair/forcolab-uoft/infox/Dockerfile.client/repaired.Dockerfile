FROM node:16 as build
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
COPY client/package.json /usr/src/app

WORKDIR /usr/src/app
RUN npm install --legacy-peer-deps && npm cache clean --force;

COPY client /usr/src/app
RUN npm run build

FROM nginx:alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
