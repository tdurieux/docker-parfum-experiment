FROM docker.io/node:erbium
WORKDIR /app
COPY issuer-web/package*.json ./
RUN npm install && npm cache clean --force;
COPY issuer-web/ .
RUN npm run build
