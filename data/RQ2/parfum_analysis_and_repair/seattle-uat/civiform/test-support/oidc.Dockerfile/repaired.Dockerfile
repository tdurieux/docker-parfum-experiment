FROM node:15-alpine

WORKDIR /usr/app
RUN npm install oidc-provider && npm cache clean --force;
ADD test_oidc_provider.js oidc.js
CMD ["node", "oidc.js"]
