FROM node:14

ADD . /app

WORKDIR /app

RUN ls /app -al

RUN yarn && yarn build @app/auth-api && yarn cache clean;

COPY apps/auth-api/package.json dist/apps/auth-api/
COPY apps/auth-api/tsconfig.build.json dist/apps/auth-api/
COPY apps/auth-api/tsconfig.json dist/apps/auth-api/

EXPOSE 4000

RUN yarn --cwd dist/apps/auth-api && yarn cache clean;
RUN yarn --cwd dist/apps/libs/modules && yarn cache clean;
RUN yarn --cwd dist/apps/libs/utils && yarn cache clean;
RUN yarn --cwd dist/apps/libs/core && yarn cache clean;

RUN ls dist/apps/auth-api -al

RUN ls /app -al

RUN yarn && yarn cache clean;

CMD yarn --cwd apps start:auth-api:prd