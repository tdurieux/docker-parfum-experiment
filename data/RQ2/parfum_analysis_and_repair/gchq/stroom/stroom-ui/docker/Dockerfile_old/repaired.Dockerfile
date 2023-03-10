#**********************************************************************
# Copyright 2018 Crown Copyright
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#**********************************************************************



# ~~~ builder stage ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM node:8.12.0-alpine AS builder
WORKDIR /root/app
RUN apk add --no-cache \
        git && \
    npm install --global yarn && npm cache clean --force;
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# ~~~ Dependencies stage ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM builder AS dependencies
COPY work/.eslintrc.js .eslintrc.js
COPY work/package.json package.json
COPY work/tsconfig.json tsconfig.json
COPY work/tsconfig.prod.json tsconfig.prod.json
COPY work/tslint.json tslint.json
COPY work/images.d.ts images.d.ts
RUN yarn install && yarn cache clean;
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# ~~~ Build stage ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM dependencies AS build
COPY --from=dependencies /root/app/node_modules /root/app/node_modules
COPY work/src src
COPY work/public public
RUN yarn build && yarn cache clean;
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# ~~~ Final stage ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM nginx:1.15.10-alpine
WORKDIR /root/app

# Set tini as entrypoint
ENTRYPOINT ["/sbin/tini", "--"]

EXPOSE 5001
EXPOSE 9446

VOLUME [ "/etc/nginx/certs" ]

# An explanation of the commands below:
#   Get all relevant environment variables...
#   ...remove the STROOM_UI tag...
#   ...lowercase them...
#   ...camelCase them...
#   ...turn them into json...
#   ...save to a file.
#   Do environment variable substitution for nginx.conf
#   Serve the statics.
CMD env | grep APP_ | \
    sed 's/APP_//g' | \
    sed -e 's/\(.*=\)/\L&/' | \
    sed -r 's/_([a-z])/\U\1/g' | \
    jo > /usr/share/nginx/html/config.json \
    && envsubst '${NGINX_HOST} \
    ${NGINX_HTTP_PORT} \
    ${NGINX_HTTPS_PORT} \
    ${NGINX_SSL_CERTIFICATE} \
    ${NGINX_SSL_CERTIFICATE_KEY} \
    ${NGINX_SSL_CLIENT_CERTIFICATE}' \
    < /etc/nginx/template/nginx.conf.template > /etc/nginx/nginx.conf \
    && nginx -g 'daemon off;'


# We need full, non-BusyBox sed
# jo is a JSON tool for generating json output on the command line.
# We use it to convert environment vars to JSON. We serve this in 'public'.
RUN apk add --no-cache \
    tini \
    sed \
    --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ jo

COPY --from=build /root/app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

# Label the image so we can see what commit/tag it came from
ARG GIT_COMMIT=unspecified
ARG GIT_TAG=unspecified
LABEL \
    git_commit="$GIT_COMMIT" \
    git_tag="$GIT_TAG"
