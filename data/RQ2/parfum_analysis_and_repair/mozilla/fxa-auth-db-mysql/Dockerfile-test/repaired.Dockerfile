FROM fxa-auth-db-mysql:build
RUN npm install && npm cache clean --force;
