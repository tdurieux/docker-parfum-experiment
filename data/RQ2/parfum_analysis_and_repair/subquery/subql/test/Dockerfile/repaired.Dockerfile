FROM node:lts-gallium
WORKDIR /workdir

COPY . .
RUN yarn && yarn cache clean;
