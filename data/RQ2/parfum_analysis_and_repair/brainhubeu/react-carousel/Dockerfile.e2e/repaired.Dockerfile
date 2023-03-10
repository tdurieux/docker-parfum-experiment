FROM cypress/included:4.9.0

WORKDIR /e2e

COPY ./package.json ./yarn.lock docs /e2e/

COPY . /e2e

# limit output by setting CI environment variable
# https://github.com/cypress-io/cypress/issues/1243
ENV CI=true
RUN yarn install --frozen-lockfile && \
    npx cypress verify && yarn cache clean;
