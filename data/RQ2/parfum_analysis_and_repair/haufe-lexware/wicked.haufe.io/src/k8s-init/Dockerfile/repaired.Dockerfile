ARG BASE_IMAGE_ALPINE
ARG SDK_TAG
FROM wicked.sdk:${SDK_TAG} as node-sdk

FROM ${BASE_IMAGE_ALPINE}

RUN mkdir -p /usr/src/app && chown -R node /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
USER node
COPY package.json /usr/src/app
COPY --from=node-sdk /wicked-sdk.tgz /usr/src/app
RUN npm install && npm cache clean --force;
COPY . /usr/src/app

CMD ["node", "index.js"]
