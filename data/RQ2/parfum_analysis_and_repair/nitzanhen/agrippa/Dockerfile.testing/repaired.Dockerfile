FROM node:14 as base

WORKDIR /usr/src/app

COPY package.json package.json
COPY yarn.lock yarn.lock
COPY src src
COPY tsconfig*.json .
COPY rollup.config.js rollup.config.js

# Build and pack agrippa

RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn build
RUN yarn pack && yarn cache clean;

FROM node:14 as test
WORKDIR /usr/src/app

# Install agrippa as a package

COPY --from=base /usr/src/app/agrippa-*.tgz ./
RUN find . -name "agrippa*.tgz" | xargs -I % sh -c "npm i -g %"

# Setup and run tests

RUN yarn init -y && yarn cache clean;
RUN yarn add --dev fast-glob@^3.2.7 jest@^27.2.4 typescript@^4.4.3 ts-jest@^27.0.5 @types/jest@^27.0.2

COPY test/end-to-end end-to-end

CMD ["yarn", "jest", "--config", "end-to-end/jest.end-to-end.config.js", "end-to-end"]