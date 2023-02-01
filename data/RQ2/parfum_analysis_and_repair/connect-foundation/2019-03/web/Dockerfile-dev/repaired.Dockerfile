FROM node:10.17 as builder

RUN mkdir /usr/src/client && rm -rf /usr/src/client
WORKDIR /usr/src/client

COPY package.json /usr/src/client/package.json
RUN npm install && npm cache clean --force;

COPY . /usr/src/client
RUN npm run build

FROM nginx:1.17.5
RUN rm -rf /etc/nginx/conf.d
RUN mkdir /etc/nginx/conf.d
COPY config/nginx/conf.d/default-dev.conf /etc/nginx/conf.d/default-dev.conf

COPY --from=builder /usr/src/client/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]