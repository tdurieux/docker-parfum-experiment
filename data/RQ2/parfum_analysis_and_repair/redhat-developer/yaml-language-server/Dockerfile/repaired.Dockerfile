FROM node:lts

WORKDIR /yaml-language-server

COPY . .

RUN yarn install && \
    yarn run build && yarn cache clean;

ENTRYPOINT [ "node", "./out/server/src/server.js" ]
CMD [ "--stdio" ]
