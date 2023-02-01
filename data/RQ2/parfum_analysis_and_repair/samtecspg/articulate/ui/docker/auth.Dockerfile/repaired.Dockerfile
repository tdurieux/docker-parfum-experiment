FROM node:10.5.0
# Needed for running yarn build
# ENV API_HOST=$API_HOST

WORKDIR /reactapp

RUN npm install -g yarn && npm cache clean --force;
COPY package.json yarn.lock ./
COPY internals ./internals

RUN yarn install && yarn cache clean;
ADD . .
# run yarn build when running yarn start:prod
# RUN yarn build

EXPOSE 3000

ENV AUTH_ENABLED=true

#CMD ["yarn", "start:prod"]
CMD ["yarn", "start"]
