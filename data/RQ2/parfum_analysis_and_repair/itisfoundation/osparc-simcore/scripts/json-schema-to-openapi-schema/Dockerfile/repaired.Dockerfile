FROM node:14.15.4-buster-slim

LABEL maintainer=sanderegg

VOLUME [ "/input" ]
VOLUME [ "/output" ]

WORKDIR /src

RUN npm install --save json-schema-to-openapi-schema && \
  npm install --save js-yaml && npm cache clean --force;
COPY converter.js /src/converter.js


CMD [ "node", "/src/converter.js" ]
