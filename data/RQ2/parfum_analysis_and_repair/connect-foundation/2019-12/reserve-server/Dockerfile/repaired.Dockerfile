FROM node:12.13.0-alpine AS build

COPY ./ /temp
WORKDIR /temp

RUN npm install -g yarn; npm cache clean --force; \
  yarn; yarn cache clean; \
  yarn build

RUN mv ./dist /server; \
  mv ./node_modules /server/node_modules; \
  mv ./package.json /server/package.json; \
  mv ./tsconfig.json /server/tsconfig.json; \
  rm -rf /temp

FROM node:12.13.0-alpine
COPY --from=build /server /server

WORKDIR /server
CMD ["npm", "run", "start:prod"]

EXPOSE 3000
