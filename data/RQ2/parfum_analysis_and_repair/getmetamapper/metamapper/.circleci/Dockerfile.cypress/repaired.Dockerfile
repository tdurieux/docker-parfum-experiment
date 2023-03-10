FROM cypress/browsers:node12.16.2-chrome81-ff75

ENV APP /usr/src/app
WORKDIR $APP

COPY www/package.json $APP/package.json

RUN npm_config_loglevel=error npm install > /dev/null && npm cache clean --force;
RUN npm_config_loglevel=error npm run cypress:install > /dev/null

COPY www $APP/www
COPY cypress.json $APP/cypress.json

RUN ./node_modules/.bin/cypress verify
