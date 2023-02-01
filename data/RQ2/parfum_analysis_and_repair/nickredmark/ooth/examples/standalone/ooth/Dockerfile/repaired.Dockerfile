FROM node:10

COPY package.json yarn.lock ./

RUN yarn && yarn cache clean;

COPY . .

ENTRYPOINT [ "yarn" ]
CMD [ "start" ]

