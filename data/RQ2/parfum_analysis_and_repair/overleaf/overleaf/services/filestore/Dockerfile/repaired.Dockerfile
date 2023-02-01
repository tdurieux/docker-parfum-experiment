# This file was auto-generated, do not edit it directly.
# Instead run bin/update_build_scripts from
# https://github.com/sharelatex/sharelatex-dev-environment

FROM node:16.14.2 as base

WORKDIR /overleaf/services/filestore
COPY services/filestore/install_deps.sh /overleaf/services/filestore/
RUN chmod 0755 ./install_deps.sh && ./install_deps.sh

# Google Cloud Storage needs a writable $HOME/.config for resumable uploads
# (see https://googleapis.dev/nodejs/storage/latest/File.html#createWriteStream)