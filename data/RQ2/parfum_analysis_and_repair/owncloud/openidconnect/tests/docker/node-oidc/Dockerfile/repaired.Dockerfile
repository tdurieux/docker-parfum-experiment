FROM node:12.2-alpine
WORKDIR /oidc
RUN apk add --no-cache git && git clone https://github.com/panva/node-oidc-provider.git . && yarn install && yarn cache clean;
EXPOSE 3000
ADD configuration.js /oidc/example/support/configuration.js

WORKDIR /oidc/example
CMD ["node", "standalone.js"]



