# build stage
FROM node:erbium as build-stage
WORKDIR /app
COPY issuer-admin/package*.json ./
RUN npm install && npm cache clean --force;
COPY issuer-admin/ .
RUN npm run build

# production stage
FROM caddy:alpine as production-stage
COPY --from=build-stage /app/dist /srv
