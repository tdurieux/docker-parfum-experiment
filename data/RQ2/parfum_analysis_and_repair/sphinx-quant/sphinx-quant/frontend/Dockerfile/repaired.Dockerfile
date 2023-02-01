FROM circleci/node:latest-browsers

WORKDIR /usr/src/app/
USER root
COPY package.json ./
RUN yarn && yarn cache clean;

COPY ./ ./

RUN npm run test:all

CMD ["npm", "run", "build"]
