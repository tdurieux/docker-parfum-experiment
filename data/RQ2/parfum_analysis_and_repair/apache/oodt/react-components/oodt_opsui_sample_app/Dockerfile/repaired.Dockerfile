FROM node:16-alpine as builder
COPY . /src
WORKDIR /src
RUN npm install && npm cache clean --force;
RUN npm run build

FROM node:16-alpine
RUN npm install -g serve && npm cache clean --force;
COPY --from=builder /src/build /opsui
WORKDIR /opsui
ENTRYPOINT ["serve", "-s"]