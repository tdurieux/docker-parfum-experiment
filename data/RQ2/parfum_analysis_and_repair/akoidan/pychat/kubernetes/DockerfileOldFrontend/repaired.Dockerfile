# cd <root>
# docker build -f ./kubernetes/DockerfileOldFrontend -t deathangel908/pychat-frontend .
# docker push deathangel908/pychat-frontend
# https://stackoverflow.com/a/49478889/3872976
# minikube tunnel service/backend-service
FROM node:16.15-alpine3.15 as builder

WORKDIR /usr/src/frontend
# for yarn install to clone via git in package.json
RUN apk add --no-cache git && mkdir /usr/src/common && rm -rf /usr/src/common
COPY ./frontend/package.json ./frontend/yarn.lock ./
COPY ./frontend/patches ./patches/
RUN yarn install --frozen-lockfile && yarn cache clean;

COPY ./frontend/tsconfig.node.json ./frontend/tsconfig.json ./
COPY ./frontend/src ./src/
COPY ./frontend/build ./build/
COPY ./kubernetes/frontend-old-pychat.org.json ./build/production.json

RUN yarn build && yarn cache clean;


FROM nginx:1.21.6-alpine

COPY --from=builder /usr/src/frontend/dist /srv/http/dist
COPY kubernetes/nginx-old-pychat.org.conf /etc/nginx/conf.d/pychat.conf
RUN rm /etc/nginx/conf.d/default.conf
