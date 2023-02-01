FROM node:lts-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . ./
RUN yarn build && yarn cache clean;

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]