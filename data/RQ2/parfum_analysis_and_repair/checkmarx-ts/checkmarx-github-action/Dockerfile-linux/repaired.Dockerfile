FROM node:latest

RUN node --version && \
    npm --version

WORKDIR /opt/checkmarx-github-action

COPY package.json ./package.json
COPY src ./src
COPY action.yml ./action.yml
COPY README.md ./README.md
COPY LICENSE ./LICENSE

RUN npm install && npm cache clean --force;

CMD [ "node", "src/index.js" ]