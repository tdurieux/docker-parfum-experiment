FROM node:10-slim as prod
ENV NODE_ENV=production
WORKDIR /app

FROM prod as dev
ENV NODE_ENV=development

FROM dev as test
ENV NODE_ENV=development
