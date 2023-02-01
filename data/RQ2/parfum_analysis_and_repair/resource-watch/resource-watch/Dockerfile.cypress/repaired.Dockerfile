FROM cypress/included:8.5.0
LABEL maintainer="hello@vizzuality.com"

WORKDIR /e2e

RUN yarn add -D "@cypress/code-coverage@3.9.11" && yarn cache clean;
RUN yarn add -D "cypress-file-upload@5.0.2" && yarn cache clean;
RUN yarn add -D "cypress-fail-fast@2.2.0" && yarn cache clean;
RUN yarn add -D "@next/env@10.0.8" && yarn cache clean;

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.8.0/wait /wait
RUN chmod +x /wait

ENTRYPOINT /wait && cypress run --headless --browser=firefox
