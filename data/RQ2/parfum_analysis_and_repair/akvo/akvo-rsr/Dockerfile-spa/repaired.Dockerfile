FROM akvo/rsr-backend-prod-no-code-with-nodejs:local

WORKDIR /var/akvo/rsr/code/akvo/rsr/spa

COPY akvo/rsr/spa /var/akvo/rsr/code/akvo/rsr/spa

RUN rm -rf node_modules && npm install && npm run production && npm cache clean --force;