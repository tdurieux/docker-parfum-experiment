FROM darpaalign/nodejs_ubuntu:02Apr19

WORKDIR /app

COPY package*.json ./

RUN \
  if [ "$http_proxy" != "" ] ; then npm config set proxy $http_proxy ; fi && \
  npm install && npm cache clean --force;

COPY . .

RUN \
  npm run build

EXPOSE 8080
CMD [ "http-server", "dist"]

