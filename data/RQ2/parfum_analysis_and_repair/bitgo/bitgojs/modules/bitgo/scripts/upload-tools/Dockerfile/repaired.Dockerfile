FROM node:10
RUN yarn global add codecov typedoc && yarn add aws-sdk && yarn cache clean;
