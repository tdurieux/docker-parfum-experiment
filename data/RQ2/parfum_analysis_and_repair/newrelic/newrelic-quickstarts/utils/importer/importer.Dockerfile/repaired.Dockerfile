FROM node:14.17.0-alpine
WORKDIR /newrelic-quickstarts/.github/actions/import-data
RUN npm install && npm cache clean --force;
ENTRYPOINT [ "npm", "run", "import"]
