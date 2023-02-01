FROM node:10 as build
WORKDIR /app
COPY . .
RUN yarn install --production=true && yarn cache clean;

FROM node:10
COPY --from=build /app /
CMD ["yarn", "trader"]