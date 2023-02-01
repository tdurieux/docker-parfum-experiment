FROM node:16
WORKDIR /app
COPY . .
RUN npm install --unsafe-perm && npm run build && npm run pkg && \
    cp vendors/config-release.json /app/config.json && npm cache clean --force;

ENTRYPOINT ["/app/dashboard"]
