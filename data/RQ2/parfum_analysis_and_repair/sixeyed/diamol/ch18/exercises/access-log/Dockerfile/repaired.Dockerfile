FROM diamol/node AS builder

WORKDIR /src
COPY src/package.json .
RUN npm install && npm cache clean --force;

# app
FROM diamol/node

EXPOSE 80
CMD ["node", "server.js"]

WORKDIR /app
COPY --from=builder /src/node_modules/ /app/node_modules/
COPY src/ .