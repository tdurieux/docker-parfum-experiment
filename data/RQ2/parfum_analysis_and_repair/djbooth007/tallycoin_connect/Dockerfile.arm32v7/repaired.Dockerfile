# Build
FROM node:16-buster-slim AS build
WORKDIR /app
COPY . .
RUN npm install && npm cache clean --force;

# Assemble
FROM arm32v7/node:16-buster-slim
WORKDIR /opt/tallycoin_connect
COPY --from=build /app/package.json /app/package-lock.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/assets ./assets
COPY --from=build /app/index.html /app/login.html /app/tallycoin_connect.js ./

# Configure and start app
EXPOSE 8123
ENV NODE_ENV production
ENTRYPOINT ["npm"]
CMD ["start"]
