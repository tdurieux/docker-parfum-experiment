# Do the npm install or yarn install in the full image
FROM mhart/alpine-node AS builder
WORKDIR /app
COPY package.json .
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn build && yarn --production

# And then copy over node_modules, etc from that stage to the smaller base image
FROM mhart/alpine-node:base
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/next.config.js ./next.config.js
EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]
