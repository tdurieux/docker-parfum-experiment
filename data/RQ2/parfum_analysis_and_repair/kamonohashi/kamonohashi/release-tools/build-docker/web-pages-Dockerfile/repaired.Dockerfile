FROM node:12.18.4-stretch AS build

COPY /web-pages /src/web-pages
RUN cd /src/web-pages && npm install && npm run build && npm cache clean --force;

COPY /web-pages-aquarium /src/web-pages-aquarium
RUN cd /src/web-pages-aquarium && npm install && npm run build && npm cache clean --force;


FROM nginx:1.17.9
COPY --from=build /src/web-pages/dist /app/kamonohashi
COPY --from=build /src/web-pages-aquarium/dist /app/aquarium