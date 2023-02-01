# build environment
FROM theasp/clojurescript-nodejs:alpine as build
COPY . /usr/src/app
WORKDIR /usr/src/app
CMD ["lein", "prod"]

# production environment