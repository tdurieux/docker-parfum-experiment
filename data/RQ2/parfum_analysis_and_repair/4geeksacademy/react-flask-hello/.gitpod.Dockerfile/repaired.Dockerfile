FROM gitpod/workspace-postgres

RUN npm i heroku -g && npm cache clean --force;
