FROM node:16-alpine as build-client

ENV REACT_APP_API_URL=/v1/api/
ENV GENERATE_SOURCEMAP=false

WORKDIR /app
COPY ./src/ui .
RUN yarn
RUN yarn build

FROM nginx:stable-alpine
COPY --from=build-client /app/build /usr/share/nginx/html
COPY deployment/nginx/nginx.default.conf /etc/nginx/conf.d/default.conf