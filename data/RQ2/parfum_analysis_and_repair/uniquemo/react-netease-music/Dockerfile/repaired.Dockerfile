FROM node:latest AS builder

WORKDIR /usr/src/app

RUN npm install -g pnpm && npm cache clean --force;
COPY package.json pnpm-lock.yaml ./
RUN pnpm install
COPY . ./
RUN pnpm run build

FROM nginx
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]
