FROM node:latest as build
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app

RUN npm install && npm cache clean --force;
RUN npm install react-scripts@1.1.1 && npm cache clean --force;

COPY . /usr/src/app
RUN npm run build

FROM nginx:alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
COPY nginx.dev.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
