FROM verdaccio/verdaccio

USER root

ENV NODE_ENV=production

RUN npm i && npm install verdaccio-aws-s3-storage && npm cache clean --force;

USER verdaccio

