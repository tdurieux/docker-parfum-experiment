# Production image for React app
FROM node:18-alpine AS builder

WORKDIR /home/node

VOLUME /home/node/node_modules

COPY . .

RUN npm i -g npm@latest \
    && npm ci --legacy-peer-deps \
    && npm run build && npm cache clean --force;


FROM nginx:alpine
COPY --from=builder /home/node/build /usr/share/nginx/html
