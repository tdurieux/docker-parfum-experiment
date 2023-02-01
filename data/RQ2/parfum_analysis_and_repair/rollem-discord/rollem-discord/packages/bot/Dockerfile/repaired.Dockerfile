FROM node:16.9

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# ONBUILD
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

COPY . .
RUN yarn install && yarn cache clean;
RUN yarn run tsc --version && yarn cache clean;
RUN yarn build:dockerfile && yarn cache clean;
EXPOSE 8080

CMD ["/bin/bash", "-c", "yarn run start-for-dockerfile"]