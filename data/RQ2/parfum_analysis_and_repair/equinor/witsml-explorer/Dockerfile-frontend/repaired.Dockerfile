FROM node:16-alpine AS builder
WORKDIR /app
COPY Src/WitsmlExplorer.Frontend/package.json ./
COPY yarn.lock ./
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY Src/WitsmlExplorer.Frontend  ./
RUN yarn test && yarn build && npm prune --production && yarn cache clean;
RUN yarn export

FROM nginx:1.22.0-alpine AS final
EXPOSE 3000

COPY --from=builder /app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/out /usr/share/nginx/html
