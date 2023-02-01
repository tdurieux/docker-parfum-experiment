# build the vuejs app
FROM node:12.13.0 as build-deps
WORKDIR /app/
COPY ./package.json /app/
RUN npm install && npm cache clean --force;
COPY . /app
RUN mkdir -p /app/build
RUN npm run build

# -------------------

# use the ngnix server to serve the built stuff
FROM nginx:1.13.3

# to help docker debugging
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y --no-install-recommends install vim curl apache2-utils && rm -rf /var/lib/apt/lists/*;

COPY --from=build-deps /app/build /app/public

COPY ./nginx.prod.conf /etc/nginx/nginx.conf.orig
RUN mkdir -p /var/log/nginx/ezmaster-front/
RUN chmod go+rwX -R /var /run

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 35268
