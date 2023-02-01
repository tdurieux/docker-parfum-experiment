FROM cypress/base:12

WORKDIR /app

RUN npm install har-validator && npm cache clean --force;
RUN npm install --save-dev --slient cypress@10.1.0 && npm cache clean --force;

RUN $(npm bin)/cypress verify

RUN mkdir /app/results

# Create this file so that we can volume mount it
RUN touch /app/cypress.config.js

# Create this folder so that we can volume mount it
RUN mkdir /app/cypress