FROM node:14-alpine

WORKDIR /bp_image_builder

ADD package.json yarn.lock ./
RUN yarn install && yarn cache clean;

ADD tsconfig.json ./
ADD src ./

RUN yarn build && yarn cache clean;

CMD [ "yarn", "start" ]