FROM node:14-alpine
RUN apk add --no-cache git
ADD . /gikopoipoi
WORKDIR /gikopoipoi
RUN yarn install && yarn cache clean;
CMD ["yarn", "dev"]