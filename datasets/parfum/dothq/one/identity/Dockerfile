FROM node:16-alpine

WORKDIR /app
COPY ./identity /app/identity
COPY ./l10n /app/l10n
RUN ls /app

WORKDIR /app/identity

RUN yarn
RUN yarn build

CMD ["yarn", "run", "serve"]