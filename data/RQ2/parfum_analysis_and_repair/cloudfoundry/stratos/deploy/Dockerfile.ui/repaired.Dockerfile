FROM splatform/stratos-ui-build-base:leap15_2 as base-build
ARG project
ARG branch
ARG commit

COPY --chown=stratos:users . /usr/src/app
WORKDIR /usr/src/app
ENV PATH="${PATH}:/usr/src/app/node_modules/.bin"

# Build front-end
RUN npm install && \
    npm run build && \
    mkdir -p /usr/dist && \
    cp -R dist/* /usr/dist && npm cache clean --force;

FROM splatform/stratos-nginx-base:leap15_2 as prod-build
RUN mkdir -p /usr/share/doc/suse
COPY  deploy/containers/nginx/LICENSE.txt /usr/share/doc/suse/LICENSE.txt
COPY  deploy/containers/nginx/conf/nginx.k8s.conf /etc/nginx/nginx.conf.tmpl
COPY --from=base-build /usr/dist /usr/share/nginx/html
COPY deploy/containers/nginx/run-nginx.sh/ /run-nginx.sh
EXPOSE 80 443
CMD [ "/run-nginx.sh" ]

FROM splatform/stratos-nginx-base:leap15_2 as dev-build
RUN mkdir -p /etc/secrets/ && \
  openssl req -batch -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/secrets/server.key -out /etc/secrets/server.crt && \
  chmod 0600 /etc/secrets && \
  chmod 0600 /etc/secrets/server.key && \
  chmod 0600 /etc/secrets/server.crt

COPY --from=base-build /usr/dist /usr/share/nginx/html
COPY  deploy/containers/nginx/conf/nginx.dev.conf /etc/nginx/nginx.conf
EXPOSE 80 443
CMD [ "nginx", "-g", "daemon off;" ]


