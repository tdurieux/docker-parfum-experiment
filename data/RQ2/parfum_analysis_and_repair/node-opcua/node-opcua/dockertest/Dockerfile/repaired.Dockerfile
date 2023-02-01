FROM node
RUN npm install -g pnpm typescript ts-node mocha && npm cache clean --force;

