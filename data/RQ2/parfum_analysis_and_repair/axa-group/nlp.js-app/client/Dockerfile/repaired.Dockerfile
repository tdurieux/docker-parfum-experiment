FROM node:8.9.4
# Needed for running yarn build
ARG API_URL=http://localhost:7500
ENV API_URL=$API_URL

WORKDIR /reactapp

RUN npm install -g yarn && npm cache clean --force;
COPY package.json yarn.lock ./
COPY internals ./internals

RUN yarn install && yarn cache clean;
ADD . .
# run yarn build when running yarn start:prod
# RUN yarn build

EXPOSE 3000

#CMD ["yarn", "start:prod"]
CMD ["yarn", "start"]
