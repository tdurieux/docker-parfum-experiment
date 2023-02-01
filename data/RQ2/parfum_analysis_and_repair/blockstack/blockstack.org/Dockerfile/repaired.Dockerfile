FROM node:12
WORKDIR /src/blockstack.org
COPY yarn.lock package.json /src/blockstack.org/
RUN yarn install && yarn cache clean;

COPY . .
ARG CACHEBUST=1
RUN yarn prod

FROM nginx
RUN apt-get update && apt-get install --no-install-recommends ssl-cert -y && rm -rf /var/lib/apt/lists/*;
COPY --from=0 /src/blockstack.org/out /usr/share/nginx/html
COPY ./nginx-default.conf /etc/nginx/conf.d/default.conf
