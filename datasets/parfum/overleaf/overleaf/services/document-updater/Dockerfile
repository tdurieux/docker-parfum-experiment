# This file was auto-generated, do not edit it directly.
# Instead run bin/update_build_scripts from
# https://github.com/sharelatex/sharelatex-dev-environment

FROM node:16.14.2 as base

WORKDIR /overleaf/services/document-updater

# Google Cloud Storage needs a writable $HOME/.config for resumable uploads
# (see https://googleapis.dev/nodejs/storage/latest/File.html#createWriteStream)
RUN mkdir /home/node/.config && chown node:node /home/node/.config

FROM base as app

COPY package.json package-lock.json /overleaf/
COPY services/document-updater/package.json /overleaf/services/document-updater/
COPY libraries/ /overleaf/libraries/

RUN cd /overleaf && npm ci --quiet

COPY services/document-updater/ /overleaf/services/document-updater/

FROM app
USER node

CMD ["node", "--expose-gc", "app.js"]
