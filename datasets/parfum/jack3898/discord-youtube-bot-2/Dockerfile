FROM node:16-alpine

ENV NODE_ENV production

WORKDIR /home/node

COPY --chown=node:node . .

USER node

RUN npm i

CMD ["npm", "run", "bot"];