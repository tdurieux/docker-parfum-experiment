# CaptainFact frontend container
# You must attach a volume containing cert.pem + privkey.pem at /etc/nginx/cert/
FROM betree/centos-nginx-nodejs:latest
MAINTAINER Benjamin Piouffle <benjamin.piouffle@gmail.com>

WORKDIR /opt/app

# Cache dependencies
COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;

# Build project
COPY . .
ARG BUILD_ENV=prod
RUN /opt/app/rel/run.sh build $BUILD_ENV

EXPOSE 80
ENTRYPOINT ["/opt/app/rel/run.sh"]
