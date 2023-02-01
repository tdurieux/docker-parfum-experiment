FROM node:14.11.0 AS client-mvp-development
RUN mkdir /srv/client && chown node:node /srv/client
WORKDIR /srv/client
USER node
RUN mkdir -p node_modules
COPY --chown=node:node package.json ./
RUN npm install --silent && npm cache clean --force;

FROM node:14.11.0-slim AS client-mvp-builder
USER node
WORKDIR /srv/client
COPY --from=client-mvp-development /srv/client/node_modules node_modules
COPY . .
USER root
RUN npm run build

FROM nginx as client-mvp-production
EXPOSE 3001
COPY /nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=client-mvp-builder /srv/client/build /usr/share/nginx/html/
CMD ["nginx", "-g", "daemon off;"]
