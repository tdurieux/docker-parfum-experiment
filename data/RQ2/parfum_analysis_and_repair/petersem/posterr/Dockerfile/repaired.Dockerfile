FROM node:14.17.3-alpine3.14

# tzdata for timzone and net-tools
RUN apk update
RUN apk add --no-cache tzdata
RUN apk add --no-cache net-tools

ENV NODE_ENV=production

WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../ && npm cache clean --force;

COPY . .
EXPOSE 3000
HEALTHCHECK --interval=10s --timeout=5s --retries=3 --start-period=15s CMD node healthcheck.js > /dev/null || exit 1
CMD ["node", "index.js"]
