FROM docker.io/node:erbium
WORKDIR /app
COPY issuer-admin/package*.json ./
RUN npm install && npm cache clean --force;
COPY issuer-admin/ .
RUN npm run build
