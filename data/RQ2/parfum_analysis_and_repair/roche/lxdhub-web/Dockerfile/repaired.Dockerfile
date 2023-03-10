FROM node:12

WORKDIR /var/lib/lxdhub-web

COPY package.json yarn.lock ./
RUN yarn --pure-lockfile --ignore-scripts && yarn cache clean;
COPY . .
RUN yarn run build && yarn cache clean;

ENTRYPOINT [ "yarn", "run" ]
CMD [ "start" ]
