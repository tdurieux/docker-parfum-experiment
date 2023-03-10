FROM node:lts-buster as builder
WORKDIR /mern-stack/client
COPY ./client ./
RUN npm ci
ARG facebook_app_id
ENV REACT_APP_FACEBOOK_APP_ID=${facebook_app_id}
ARG google_client_id
ENV REACT_APP_GOOGLE_CLIENT_ID=${google_client_id}
ARG version
ENV REACT_APP_VERSION=${version}
RUN npm run build

FROM nginx:stable-alpine
COPY --from=builder /mern-stack/client/build /usr/share/nginx/html
COPY ./client/nginx.service.conf.prod /etc/nginx/conf.d/default.conf
EXPOSE 3000
CMD ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && nginx -g "daemon off;"