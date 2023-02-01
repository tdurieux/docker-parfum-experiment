FROM node:current-buster-slim

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY ./ /usr/src/app/

RUN npm i -g lerna && npm cache clean --force;
RUN	npm ci --no-audit --production

ENV NODE_ENV production
EXPOSE 4000

CMD ["node", "projects/backend/build/index.js"]