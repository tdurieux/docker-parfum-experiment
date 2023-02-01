FROM node as jsbuilder

COPY . /app
WORKDIR /app

RUN npm install && npm cache clean --force;

# ---------------------------------------------------------

FROM node:slim

COPY --from=jsbuilder /app /app

WORKDIR /app

EXPOSE 3000
ENTRYPOINT [ "node", "index.js" ]
