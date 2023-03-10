# build stage
FROM node:erbium as build-stage
WORKDIR /app
COPY issuer-web/package*.json ./
RUN npm install && npm cache clean --force;
COPY issuer-web/ .
RUN npm run build

# production stage
FROM caddy:alpine as production-stage
COPY --from=build-stage /app/dist /srv
