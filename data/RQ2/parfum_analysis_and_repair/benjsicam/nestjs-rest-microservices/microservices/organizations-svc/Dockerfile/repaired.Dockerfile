FROM node:12-alpine as build

WORKDIR /usr/local/organizations-svc

COPY dist package.json ./

RUN npm install --production && npm cache clean --force;

FROM node:12-alpine

WORKDIR /usr/local/organizations-svc

COPY --from=build /usr/local/organizations-svc .

EXPOSE 50051

CMD ["node", "main.js"]
