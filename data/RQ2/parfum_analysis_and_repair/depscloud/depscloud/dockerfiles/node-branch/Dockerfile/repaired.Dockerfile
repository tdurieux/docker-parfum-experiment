ARG NODE_VERSION=16

FROM node:${NODE_VERSION}
RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/depscloud

ARG VERSION=""
ARG GIT_SHA=""
ARG BINARY

COPY services/${BINARY}/package.json .
COPY services/${BINARY}/package-lock.json .

RUN npm install && npm cache clean --force;

COPY services/${BINARY}/ .

RUN npm run build && \
    npm run prepackage

USER 13490:13490

ENTRYPOINT [ "npm", "start", "--" ]
