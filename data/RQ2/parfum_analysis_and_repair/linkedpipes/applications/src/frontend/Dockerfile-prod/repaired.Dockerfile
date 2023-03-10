# build environment
FROM node:10.16.3-alpine as builder

ENV YARN_VERSION 1.17.0
# Install packages using Yarn
# References:
# http://bitjudo.com/blog/2014/03/13/building-efficient-dockerfiles-node-dot-js/
# https://hackernoon.com/using-yarn-with-docker-c116ad289d56

# Add package.json and respective lock
ADD package.json yarn.* /tmp/

# Install git
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN apk add --no-cache --virtual .build-deps-yarn curl \
    && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz \
    && apk del .build-deps-yarn

# Install packages
RUN cd /tmp && until yarn install --frozen-lockfile ; do echo "Retrying yarn install..."; done && yarn cache clean;

# Create a symlink to node_modules
RUN mkdir -p /usr/src/app && cd /usr/src/app && ln -s /tmp/node_modules && rm -rf /usr/src/app

WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY . /usr/src/app
RUN yarn build


# Production environment image
FROM nginx:alpine
COPY --from=builder /usr/src/app/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
