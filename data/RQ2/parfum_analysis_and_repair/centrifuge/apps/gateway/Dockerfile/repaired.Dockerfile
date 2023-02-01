FROM node:12.19.0

WORKDIR /usr/src/app

COPY . ./

# https://github.com/npm/npm/issues/18163
RUN npm config set unsafe-perm true

RUN yarn install && yarn cache clean;

# install rsync to copy over build files
RUN apt-get update -y && apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;

RUN yarn workspace centrifuge-gateway build && yarn cache clean;
RUN yarn workspace centrifuge-gateway move:assets && yarn cache clean;

EXPOSE 3001

CMD ["yarn", "workspace", "centrifuge-gateway", "run", "start:prod"]
