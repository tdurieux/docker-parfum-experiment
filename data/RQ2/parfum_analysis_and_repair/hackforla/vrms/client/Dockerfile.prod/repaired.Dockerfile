FROM node:14.11.0 AS node-modules-install
RUN mkdir /srv/client && chown node:node /srv/client
WORKDIR /srv/client
USER node
RUN mkdir -p node_modules
COPY --chown=node:node package.json package.json ./
RUN npm install --silent && npm cache clean --force;

FROM node:14.11.0-slim AS client-builder
USER node
WORKDIR /srv/client
COPY --from=node-modules-install /srv/client/node_modules node_modules
COPY . .
USER root
ARG CUSTOM_REQUEST_HEADER nAb3kY-S%qE#4!d
ENV REACT_APP_CUSTOM_REQUEST_HEADER $CUSTOM_REQUEST_HEADER
RUN npm run build

FROM nginx as client-production
EXPOSE 3000
COPY /nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=client-builder /srv/client/build /usr/share/nginx/html/
CMD ["nginx", "-g", "daemon off;"]
