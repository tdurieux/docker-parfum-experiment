FROM node:13-slim

WORKDIR /project-noe/frontend

COPY ./package.json package.json
COPY ./tsconfig.json tsconfig.json
RUN yarn && yarn cache clean;

CMD yarn start 0.0.0.0