FROM node:16.6-alpine3.14

ENV APP_HOME /app
WORKDIR $APP_HOME

# toolchain for deps (bcrypt)
RUN apk add --no-cache python3 make g++ postgresql-client

COPY package.json .
COPY yarn.lock .
COPY packages/web/ ./packages/web/
# web depends on tests
COPY packages/tests/ ./packages/tests/
RUN yarn workspace web install --frozen-lockfile

WORKDIR $APP_HOME/packages/web/
RUN yarn run css:build

ENV PORT 3000
EXPOSE $PORT

ENTRYPOINT yarn run start