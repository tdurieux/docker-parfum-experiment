FROM node:12 as build

COPY . /srv
WORKDIR /srv/
RUN yarn && yarn build && yarn export

# Stage - Production
FROM nginx:1.17-alpine
COPY --from=build /srv/out /usr/share/nginx/html
EXPOSE 80
ENTRYPOINT echo ${PROXY_ENDPOINT} > /usr/share/nginx/html/proxy-host && \
           nginx -g "daemon off;"