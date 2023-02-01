FROM node:16-buster AS build
WORKDIR /build
COPY package*.json ./
RUN npm install && npm cache clean --force;

FROM node:16-buster-slim

WORKDIR /app
COPY --from=build /build/node_modules ./node_modules
COPY . .

EXPOSE 3000
ENV NODE_ENV=production
RUN chown node:node ./db
USER node

CMD ["node", "index.js"]
