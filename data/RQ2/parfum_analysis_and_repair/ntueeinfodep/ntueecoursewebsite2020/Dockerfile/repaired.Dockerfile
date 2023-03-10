FROM node:12-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

FROM node:12-alpine
RUN mkdir -p /app/node_modules && chown -R node:node /app
WORKDIR /app
COPY --chown=node:node package*.json ./
USER node
RUN npm install --production && npm cache clean --force;
COPY --chown=node:node --from=build /app/assets /app/assets
COPY --chown=node:node --from=build /app/build /app/build
COPY --chown=node:node --from=build /app/bundle /app/bundle
EXPOSE 8000
ENTRYPOINT ["node", "build/server.js"]
