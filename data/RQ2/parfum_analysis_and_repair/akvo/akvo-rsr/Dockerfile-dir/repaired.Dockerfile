FROM akvo/rsr-backend-prod-no-code-with-nodejs:local

WORKDIR /var/akvo/rsr/code/akvo/rsr/dir

COPY akvo/rsr/dir /var/akvo/rsr/code/akvo/rsr/dir

RUN rm -rf node_modules && npm install && npm run production && npm cache clean --force;