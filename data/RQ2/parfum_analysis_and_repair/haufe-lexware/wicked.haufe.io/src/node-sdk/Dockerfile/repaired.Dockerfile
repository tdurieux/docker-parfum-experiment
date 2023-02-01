ARG BASE_IMAGE_ALPINE
FROM ${BASE_IMAGE_ALPINE}

RUN apk update && apk add --no-cache jq
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# This is okay, as it's only the builder image. This will not work on Jenkins otherwise.
RUN npm config set unsafe-perm true
RUN npm install -g npm-cli-login typescript@$(jq .devDependencies.typescript | tr -d '"') && npm cache clean --force;
COPY package.json /usr/src/app
COPY . /usr/src/app

RUN npm install && npm cache clean --force;
RUN tsc
RUN export PACKAGE_FILE=$(npm pack) && cp ${PACKAGE_FILE} /wicked-sdk.tgz
