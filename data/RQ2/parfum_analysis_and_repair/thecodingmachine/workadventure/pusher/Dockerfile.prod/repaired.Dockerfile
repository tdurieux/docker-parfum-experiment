FROM node:16.15-buster-slim@sha256:9ad2f889d4a15ef94e40ac75e95c28daa34073dbc25d7b1e619caacc6b83623c

RUN mkdir -p /home/node/app && chown -R node:node /home/node/app
WORKDIR /home/node/app

USER node
ENV NODE_ENV=production
ENV DEBUG=*

COPY --chown=node:node package.json yarn.lock ./

RUN yarn install --prod --frozen-lockfile && yarn cache clean;

COPY --chown=node:node ./dist/ ./dist/

EXPOSE 8080
CMD ["yarn", "run", "runprod"]
