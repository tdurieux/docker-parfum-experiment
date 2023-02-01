FROM node:alpine
MAINTAINER Alexander Kern <filepizza@kern.io>

COPY . ./
RUN npm install && npm run build && npm cache clean --force;

ENV NODE_ENV production
EXPOSE 80
CMD node ./dist/index.js
