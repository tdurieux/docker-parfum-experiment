# Only for technical/build aims, built image will be with nginx:alpine according to the last step
FROM alpine:3.10.9 as generate-build-info
RUN apk add --no-cache git
RUN apk add --no-cache make
RUN mkdir -p /usr/src/app/build && rm -rf /usr/src/app/build
COPY ./Makefile /usr/src/
WORKDIR /usr/src
ARG version
RUN make generate-build-info v=$version

FROM node:12-alpine as build-frontend
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY ./app/ /usr/src/app/
RUN export NODE_OPTIONS="--max-old-space-size=4096"
RUN npm ci && npm run build && npm run test

FROM nginx:alpine
COPY --from=build-frontend /usr/src/app/build /usr/share/nginx/html
COPY --from=generate-build-info /usr/src/app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
