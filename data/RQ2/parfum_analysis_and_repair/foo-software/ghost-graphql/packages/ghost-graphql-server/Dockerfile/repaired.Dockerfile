FROM node:10.15.0

RUN npm install @foo-software/ghost-graphql-server -g && npm cache clean --force;

CMD ["ghost-graphql-server"]
