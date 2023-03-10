FROM node:9 AS build
WORKDIR /srv
ADD package.json .
RUN npm install && npm cache clean --force;

FROM node:9-slim
COPY --from=build /srv .
ADD . .
EXPOSE 3000
CMD ["node", "index.js"]
