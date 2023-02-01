FROM node:12-alpine AS builder

WORKDIR /app
COPY ./package.json ./
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn run build


FROM node:12-alpine
WORKDIR /app
COPY --from=builder /app ./
CMD ["yarn", "run", "start:prod"]


