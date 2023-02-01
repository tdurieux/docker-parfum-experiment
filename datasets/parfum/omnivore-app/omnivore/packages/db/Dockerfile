FROM node:14.18-alpine

WORKDIR /app

COPY package.json .
COPY yarn.lock .
COPY tsconfig.json .

COPY /packages/db/package.json ./packages/db/package.json

RUN apk --no-cache --virtual build-dependencies add postgresql

RUN yarn install

ADD /packages/db ./packages/db
ADD /packages/db/setup.sh ./packages/db/setup.sh
ADD /packages/db/elastic_migrations ./packages/db/elastic_migrations

CMD ["yarn", "workspace", "@omnivore/db", "migrate"]
