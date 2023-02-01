FROM spree/test-runtime

FROM cypress/included:9.1.0

COPY --from=0 /sdk /sdk

WORKDIR /app

COPY ./tests /app

RUN npm install && npm cache clean --force;

RUN npm i node-fetch && npm cache clean --force;

ENTRYPOINT /app/cypress-docker-entrypoint.sh
