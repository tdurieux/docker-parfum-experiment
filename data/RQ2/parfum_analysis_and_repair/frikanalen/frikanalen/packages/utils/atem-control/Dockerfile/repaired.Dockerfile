FROM node:16-alpine AS builder

WORKDIR /app

COPY . .

RUN yarn install --quiet --dev && yarn cache clean;
RUN yarn build && yarn cache clean;

FROM node:16-alpine

COPY --from=builder /app/dist dist
COPY --from=builder /app/node_modules node_modules
COPY yarn.lock package.json tsconfig.json ./

EXPOSE 80

CMD ["yarn", "start"]