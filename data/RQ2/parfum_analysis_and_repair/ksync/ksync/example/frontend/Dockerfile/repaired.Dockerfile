FROM node:alpine as builder
WORKDIR /code
COPY . .
RUN npm install && \
  npm run build && npm cache clean --force;

FROM nginx:alpine
COPY --from=builder /code/build/ /data/
