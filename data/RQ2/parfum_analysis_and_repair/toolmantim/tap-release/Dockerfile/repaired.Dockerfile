FROM    node:10-alpine
WORKDIR /src
ADD     yarn.lock package.json /src/
RUN yarn && yarn cache clean;
ADD     . /src
CMD     ["npm", "start"]