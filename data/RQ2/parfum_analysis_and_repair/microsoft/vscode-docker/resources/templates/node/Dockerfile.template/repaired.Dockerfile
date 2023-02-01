FROM node:lts-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../ && npm cache clean --force;
COPY . .
{{#each ports}}
EXPOSE {{ . }}
{{/each}}
RUN chown -R node /usr/src/app
USER node
CMD {{{ toQuotedArray nodeCmdParts }}}
